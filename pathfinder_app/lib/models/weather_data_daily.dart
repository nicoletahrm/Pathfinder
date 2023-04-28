import 'package:pathfinder_app/models/weather/temp.dart';
import 'package:pathfinder_app/models/weather/weather.dart';

class WeatherDataDaily {
  List<Daily> daily;

  WeatherDataDaily({required this.daily});

  List<Daily> getWeatherDataDaily() => daily;

  factory WeatherDataDaily.fromJson(Map<String, dynamic> json) =>
      WeatherDataDaily(
          daily: List<Daily>.from(json['daily'].map((e) => Daily.fromJson(e))));
}

class Daily {
  int? sunset;
  Temp? temp;
  double? windSpeed;
  List<Weather>? weather;
  int? clouds;
  double? rain;

  Daily({
    this.sunset,
    this.temp,
    this.windSpeed,
    this.weather,
    this.clouds,
    this.rain,
  });

  @override
  String toString() {
    return 'Daily(sunset: $sunset, temp: $temp, windSpeed: $windSpeed, weather: $weather, clouds: $clouds, rain: $rain)';
  }

  factory Daily.fromJson(Map<String, dynamic> data) => Daily(
        sunset: data['sunset'] as int?,
        temp: data['temp'] == null
            ? null
            : Temp.fromJson(data['temp'] as Map<String, dynamic>),
        windSpeed: (data['wind_speed'] as num?)?.toDouble(),
        weather: (data['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
        clouds: data['clouds'] as int?,
        rain: (data['rain'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'sunset': sunset,
        'temp': temp?.toJson(),
        'wind_speed': windSpeed,
        'weather': weather?.map((e) => e.toJson()).toList(),
        'clouds': clouds,
        'rain': rain,
      };
}
