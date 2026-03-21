import 'package:farmsetu_weather/model/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());

final currentWeatherProvider = FutureProvider.family<Map<String, dynamic>, (double, double)>((ref, coords) async {
  final service = ref.watch(weatherServiceProvider);
  return await service.getCurrentWeather(coords.$1, coords.$2);
});

final dailyForecastProvider = FutureProvider.family<List<DailyWeather>, (double, double)>((ref, coords) async {
  final service = ref.watch(weatherServiceProvider);
  return await service.getDailyForecast(coords.$1, coords.$2);
});