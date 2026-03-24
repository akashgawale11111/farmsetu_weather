import 'package:farmsetu_weather/services/provider/weather_provider.dart';
import 'package:farmsetu_weather/services/geocoding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'weather_detail_screen.dart';
import 'package:intl/intl.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  final GeocodingService _geocodingService = GeocodingService();
  final TextEditingController _searchController = TextEditingController();
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
  LatLng? _currentPosition;
  LatLng? _selectedPosition;
  String _selectedLocationName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    var permission = await Permission.location.request();
    if (!permission.isGranted) {
      permission = await Permission.location.request();
      if (!permission.isGranted) return;
    }

    final locationData = await _location.getLocation();
    final lat = locationData.latitude ?? 0.0;
    final lng = locationData.longitude ?? 0.0;

    setState(() {
      _currentPosition = LatLng(lat, lng);
      _selectedPosition = _currentPosition;
    });

    // Move the camera if the map controller is ready
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 12),
      );
    }

    // Show weather popup for the new location
    _showWeatherPopup(_currentPosition!);
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
    });
    // Get location name from coordinates
    try {
      final name = await _geocodingService.reverseGeocode(
          position.latitude, position.longitude);
      setState(() {
        _selectedLocationName = name;
      });
      _showWeatherPopup(position);
    } catch (e) {
      setState(() {
        _selectedLocationName = 'Unknown Location';
      });
      _showWeatherPopup(position);
    }
  }

  void _showWeatherPopup(LatLng position) async {
    if (position.latitude == 0.0 && position.longitude == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid location coordinates')),
      );
      return;
    }

    try {
      final weather = await ref.read(
          currentWeatherProvider((position.latitude, position.longitude))
              .future);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(_selectedLocationName.isNotEmpty
              ? _selectedLocationName
              : 'Weather'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(dateFormat.format(weather.date)),
                  subtitle: Text(
                    'Max: ${weather.maxTemp}°C  Min: ${weather.minTemp}°C\n'
                    'Wind: ${weather.windSpeed} km/h',
                  ),
                  trailing: Text('Code: ${weather.weatherCode}'),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WeatherDetailScreen(
                      latitude: position.latitude,
                      longitude: position.longitude,
                      locationName: _selectedLocationName,
                    ),
                  ),
                );
              },
              child: const Text('Details'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather: $e')),
      );
    }
  }

  Future<void> _searchCity() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final results = await _geocodingService.searchCity(query);

      if (results.isNotEmpty) {
        final first = results.first;

        final lat = first['latitude'] as double;
        final lng = first['longitude'] as double;
        final name = first['name'] as String;

        final newPosition = LatLng(lat, lng);

        setState(() {
          _selectedPosition = newPosition;
          _selectedLocationName = name;
        });

        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 12),
        );

        _onMapTapped(newPosition);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor:  const Color.fromARGB(255, 249, 235, 255),
        title: const Text('Farmer Weather'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (_) => _searchCity,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search city...',
                       border: OutlineInputBorder(
                        borderSide:  const BorderSide(
                            color: Colors.orange),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchCity,
                ),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
          ),
        ),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 12,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                // Now that the map controller is initialized, animate to current location
                _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentPosition!, 12));
                // Show weather popup for current location
                _showWeatherPopup(_currentPosition!);
              },
              onTap: _onMapTapped,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _selectedPosition != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedPosition!,
                        infoWindow: InfoWindow(title: _selectedLocationName),
                      )
                    }
                  : {},
            ),
    );
  }
}
