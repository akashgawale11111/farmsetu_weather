import 'package:dio/dio.dart';
import 'package:farmsetu_weather/services/constants.dart';
import 'package:farmsetu_weather/services/model/weather_model.dart';


class WeatherService {
  final Dio _dio = Dio();

  /// Original method that returns raw OpenWeatherMap current weather data.
  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    // Validate coordinates
    if (lat == 0.0 && lon == 0.0) {
      throw Exception('Invalid coordinates: lat and lon cannot both be zero');
    }

    final url = '${Constants.weatherBaseUrl}/weather'
        '?lat=$lat&lon=$lon'
        '&appid=${Constants.openWeatherApiKey}'
        '&units=metric'; // Celsius

    // print('🌤️ Requesting: $url');

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // print('❌ Dio error: ${e.message}');
      // print('Response: ${e.response?.data}');
      throw Exception('Weather API error: ${e.message}');
    }
  }

  /// Simplified method that extracts only the fields needed for the popup.
  Future<Map<String, dynamic>> getCurrentWeatherSimple(double lat, double lon) async {
    final raw = await getCurrentWeather(lat, lon); // Now this will work
    return {
      'temperature': raw['main']['temp'],
      'windspeed': raw['wind']['speed'],
      'weathercode': raw['weather'][0]['id'],
    };
  }

  /// Forecast method – unchanged from your previous version.
  Future<List<DailyWeather>> getDailyForecast(double lat, double lon) async {
    final url = '${Constants.weatherBaseUrl}/forecast'
        '?lat=$lat&lon=$lon'
        '&appid=${Constants.openWeatherApiKey}'
        '&units=metric';

    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final data = response.data;
      final List<dynamic> list = data['list']; // 3‑hour steps
      final Map<String, List<Map<String, dynamic>>> grouped = {};

      for (var entry in list) {
        final dtTxt = entry['dt_txt']; // format "2025-03-21 12:00:00"
        final dateStr = dtTxt.split(' ')[0]; // YYYY-MM-DD
        grouped.putIfAbsent(dateStr, () => []).add(entry);
      }

      // Build daily summaries
      final List<DailyWeather> dailyList = [];
      for (var entry in grouped.entries) {
        final date = DateTime.parse(entry.key);
        final temps = entry.value.map((e) => e['main']['temp'].toDouble()).toList();
        final winds = entry.value.map((e) => e['wind']['speed'].toDouble()).toList();
        final weatherCodes = entry.value.map((e) => e['weather'][0]['id']).toList();

        dailyList.add(DailyWeather(
          date: date,
          maxTemp: temps.reduce((a, b) => a > b ? a : b),
          minTemp: temps.reduce((a, b) => a < b ? a : b),
          precipitation: 0.0, // Free API does not provide precipitation amount, only probability
          windSpeed: winds.reduce((a, b) => a > b ? a : b),
          weatherCode: weatherCodes.first, // Use first code of the day
        ));
      }
      // Sort by date and return
      dailyList.sort((a, b) => a.date.compareTo(b.date));
      return dailyList;
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}