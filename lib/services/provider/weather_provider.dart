import 'package:farmsetu_weather/services/model/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../weather_service.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());

final currentWeatherProvider =
    FutureProvider.family<DailyWeather, (double, double)>(
        (ref, coords) async {
  final service = ref.watch(weatherServiceProvider);
  return await service.getCurrentWeatherSimple(coords.$1, coords.$2);
});

final dailyForecastProvider =
    FutureProvider.family<List<DailyWeather>, (double, double)>(
        (ref, coords) async {
  final service = ref.watch(weatherServiceProvider);
  return await service.getDailyForecast(coords.$1, coords.$2);
});
