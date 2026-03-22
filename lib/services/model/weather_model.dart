

/// Daily aggregated weather (min/max from 3‑hour steps)
class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final double precipitation; // Not available in free forecast – set to 0 or use rain probability
  final double windSpeed;
  final int weatherCode; // We'll map OpenWeather icon codes to ints for consistency

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
    required this.windSpeed,
    required this.weatherCode,
  });
}