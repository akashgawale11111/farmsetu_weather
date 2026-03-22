// geocoding_service.dart
import 'package:dio/dio.dart';
import 'package:farmsetu_weather/services/constants.dart';

class GeocodingService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> searchCity(String query) async {
    final url = '${Constants.geocodingBaseUrl}/direct?q=$query&limit=5&appid=${Constants.openWeatherApiKey}';
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final results = response.data as List;
      return results.map((r) => {
        'name': r['name'] ?? 'Unknown',
        'latitude': r['lat'] as double,
        'longitude': r['lon'] as double,
      }).toList();
    } else {
      throw Exception('Failed to search city');
    }
  }

  Future<String> reverseGeocode(double latitude, double longitude) async {
    final url = '${Constants.geocodingBaseUrl}/reverse?lat=$latitude&lon=$longitude&limit=1&appid=${Constants.openWeatherApiKey}';
    final response = await _dio.get(url);
    if (response.statusCode == 200 && response.data is List && response.data.isNotEmpty) {
      final first = response.data[0];
      final name = first['name'];
      final state = first['state'];
      final country = first['country'];
      return [name, state, country].where((e) => e != null).join(', ');
    } else {
      return 'Unknown location';
    }
  }
}