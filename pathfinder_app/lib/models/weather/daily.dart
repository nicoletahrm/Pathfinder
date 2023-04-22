import 'dart:convert';
import 'temp.dart';

class Daily {
  int? sunset;
  Temp? temp;
  double? windSpeed;
  //List<Weather>? weather;
  int? clouds;
  double? rain;

  Daily({
    this.sunset,
    this.temp,
    this.windSpeed,
    //this.weather,
    this.clouds,
    this.rain,
  });

  @override
  String toString() {
    return 'Daily(sunset: $sunset, temp: $temp, windSpeed: $windSpeed, clouds: $clouds, rain: $rain)';
  }

  factory Daily.fromFrom(Map<String, dynamic> data) => Daily(
        sunset: data['sunset'] as int?,
        temp: data['temp'] == null
            ? null
            : Temp.fromJson(data['temp'] as Map<String, dynamic>),
        windSpeed: (data['wind_speed'] as num?)?.toDouble(),
        clouds: data['clouds'] as int?,
        rain: (data['rain'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toFrom() => {
        'sunset': sunset,
        'temp': temp?.toJson(),
        'wind_speed': windSpeed,
        'clouds': clouds,
        'rain': rain,
      };

  /// Parses the string and returns the resulting Json object as [Daily].
  factory Daily.fromJson(String data) {
    return Daily.fromFrom(json.decode(data) as Map<String, dynamic>);
  }

  /// Converts [Daily] to a JSON string.
  String toJson() => json.encode(toFrom());
}
