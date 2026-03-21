import 'package:farmsetu_weather/provider/weather_provider.dart';
import 'package:farmsetu_weather/services/geocoding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'weather_detail_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController _mapController;
  final loc.Location _location = loc.Location();
  final GeocodingService _geocodingService = GeocodingService();
  final TextEditingController _searchController = TextEditingController();
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
    _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 12));
    _showWeatherPopup(_currentPosition!);
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
    });
    // Get location name from coordinates
    final name = await _geocodingService.reverseGeocode(
        position.latitude, position.longitude);
    setState(() {
      _selectedLocationName = name;
    });
    _showWeatherPopup(position);
  }

  void _showWeatherPopup(LatLng position) async {
    try {
      final weather = await ref.read(
          currentWeatherProvider((position.latitude, position.longitude)).future);
      final temp = (weather as Map<String, dynamic>)['temperature'] ?? 0.0;
      final wind = (weather as Map<String, dynamic>)['windspeed'] ?? 0.0;
      final weatherCode = (weather as Map<String, dynamic>)['weathercode'] ?? 0;

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
              Text('Temperature: $temp°C'),
              Text('Wind Speed: $wind km/h'),
              Text('Weather Code: $weatherCode'),
              const SizedBox(height: 8),
              const Text('Tap for full details & 7‑day forecast'),
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
    final results = await _geocodingService.searchCity(query);
    if (results.isNotEmpty) {
      final first = results.first;
      final lat = first['latitude'] as double;
      final lng = first['longitude'] as double;
      final name = first['name'] as String;
      setState(() {
        _selectedPosition = LatLng(lat, lng);
        _selectedLocationName = name;
      });
      _mapController
          .animateCamera(CameraUpdate.newLatLngZoom(_selectedPosition!, 12));
      _showWeatherPopup(_selectedPosition!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Weather'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search city...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
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
              onMapCreated: (controller) => _mapController = controller,
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
