import 'package:dio/dio.dart';
import 'package:farmsetu_weather/constants.dart';


class GeocodingService {
  final Dio _dio = Dio();

  /// Search city by name, returns list of (name, latitude, longitude)
  Future<List<Map<String, dynamic>>> searchCity(String query) async {
    final url = '${Constants.geocodingBaseUrl}/search?name=$query&count=5&language=en';
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final results = response.data as List;
      return results.map((r) => {
        'name': r['display_name'],
        'latitude': r['lat'],
        'longitude': r['lon'],
      }).toList();
    } else {
      throw Exception('Failed to search city');
    }
  }

  /// Reverse geocode: get city name from coordinates
  Future<String> reverseGeocode(double latitude, double longitude) async {
    final url = '${Constants.geocodingBaseUrl}/reverse?lat=$latitude&lon=$longitude&format=json';
    final response = await _dio.get(url);
    if (response.statusCode == 200 && response.data != null) {
      return response.data['display_name'] ?? 'Unknown location';
    } else {
      return 'Unknown location';
    }
  }
}