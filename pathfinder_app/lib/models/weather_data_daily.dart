import 'package:pathfinder_app/models/weather/temp.dart';
import 'package:pathfinder_app/models/weather/weather.dart';

class WeatherDataDaily {
  List<Daily> daily;

  WeatherDataDaily({required this.daily});

  factory WeatherDataDaily.fromJson(Map<String, dynamic> json) =>
      WeatherDataDaily(
          daily: List<Daily>.from(json['daily'].map((e) => Daily.fromJson(e))));
}

class Daily {
  int? dt;
  int? sunset;
  Temp? temp;
  int? pressure;
  int? humidity;
  double? dewPoint;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;
  int? clouds;
  double? pop;
  double? uvi;
  double? rain;

  Daily({
    this.dt,
    this.sunset,
    this.temp,
    this.humidity,
    this.windSpeed,
    this.weather,
    this.clouds,
    this.pop,
    this.uvi,
    this.rain,
  });

  @override
  String toString() {
    return 'Daily(dt: $dt, sunset: $sunset, temp: $temp, pressure: $pressure, humidity: $humidity, dewPoint: $dewPoint, windSpeed: $windSpeed, windDeg: $windDeg, windGust: $windGust, weather: $weather, clouds: $clouds, pop: $pop, uvi: $uvi, rain: $rain)';
  }

  factory Daily.fromJson(Map<String, dynamic> data) => Daily(
        dt: data['dt'] as int?,
        sunset: data['sunset'] as int?,
        temp: data['temp'] == null
            ? null
            : Temp.fromFrom(data['temp'] as Map<String, dynamic>),
        humidity: data['humidity'] as int?,
        windSpeed: (data['wind_speed'] as num?)?.toDouble(),
        weather: (data['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromFrom(e as Map<String, dynamic>))
            .toList(),
        clouds: data['clouds'] as int?,
        pop: (data['pop'] as num?)?.toDouble(),
        uvi: (data['uvi'] as num?)?.toDouble(),
        rain: (data['rain'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunset': sunset,
        'temp': temp?.toFrom(),
        'pressure': pressure,
        'humidity': humidity,
        'wind_speed': windSpeed,
        'weather': weather?.map((e) => e.toFrom()).toList(),
        'clouds': clouds,
        'pop': pop,
        'uvi': uvi,
        'rain': rain,
      };
}
