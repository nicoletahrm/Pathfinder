import 'dart:convert';
import 'weather.dart';

class Current {
  int? sunrise;
  int? sunset;
  double? temp;
  int? clouds;
  double? windSpeed;
  List<Weather>? weather;

  Current({
    this.sunrise,
    this.sunset,
    this.temp,
    this.clouds,
    this.windSpeed,
    this.weather,
  });

  @override
  String toString() {
    return 'Current(sunrise: $sunrise, sunset: $sunset, temp: $temp, clouds: $clouds, windSpeed: $windSpeed, weather: $weather)';
  }

  factory Current.fromFrom(Map<String, dynamic> data) => Current(
        sunrise: data['sunrise'] as int?,
        sunset: data['sunset'] as int?,
        temp: (data['temp'] as num?)?.toDouble(),
        clouds: data['clouds'] as int?,
        windSpeed: (data['wind_speed'] as num?)?.toDouble(),
        weather: (data['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toFrom() => {
        'sunrise': sunrise,
        'sunset': sunset,
        'temp': temp,
        'clouds': clouds,
        'wind_speed': windSpeed,
        'weather': weather?.map((e) => e.toJson()).toList(),
      };

  /// Parses the string and returns the resulting Json object as [Current].
  factory Current.fromJson(String data) {
    return Current.fromFrom(json.decode(data) as Map<String, dynamic>);
  }

  /// Converts [Current] to a JSON string.
  String toJson() => json.encode(toFrom());
}
