import 'package:farmsetu_weather/services/model/weather_model.dart';
import 'package:farmsetu_weather/services/provider/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WeatherDetailScreen extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const WeatherDetailScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  ConsumerState<WeatherDetailScreen> createState() =>
      _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends ConsumerState<WeatherDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final forecastAsync =
        ref.watch(dailyForecastProvider((widget.latitude, widget.longitude)));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationName),
      ),
      body: forecastAsync.when(
        data: (dailyForecast) {
          // dailyForecast contains up to 5 days (next 5 days)
          final currentDay =
              dailyForecast.isNotEmpty ? dailyForecast.first : null;
          final futureDays = dailyForecast.skip(1).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (currentDay != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Weather',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _buildWeatherTile(currentDay),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (futureDays.isNotEmpty) ...[
                Text(
                  'Next ${futureDays.length} Days Forecast',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...futureDays.map((day) => _buildWeatherTile(day)).toList(),
              ],
              // Show a message about missing historical data
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Previous 7 days and full 7‑day forecast require a paid OpenWeatherMap subscription. '
                        'Upgrade to One Call API 3.0 for complete historical data.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildWeatherTile(DailyWeather weather) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(dateFormat.format(weather.date)),
        subtitle: Text(
          'Max: ${weather.maxTemp}°C  Min: ${weather.minTemp}°C\n'
          'Wind: ${weather.windSpeed} km/h',
        ),
        trailing: Text('Code: ${weather.weatherCode}'),
      ),
    );
  }
}
