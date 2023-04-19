import 'dart:convert';

import 'weather.dart';

class Current {
  int? dt;
  int? sunrise;
  int? sunset;
  double? temp;
  double? feelsLike;
  int? pressure;
  int? humidity;
  double? dewPoint;
  int? uvi;
  int? clouds;
  int? visibility;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;

  Current({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
  });

  @override
  String toString() {
    return 'Current(dt: $dt, sunrise: $sunrise, sunset: $sunset, temp: $temp, feelsLike: $feelsLike, pressure: $pressure, humidity: $humidity, dewPoint: $dewPoint, uvi: $uvi, clouds: $clouds, visibility: $visibility, windSpeed: $windSpeed, windDeg: $windDeg, windGust: $windGust, weather: $weather)';
  }

  factory Current.fromFrom(Map<String, dynamic> data) => Current(
        dt: data['dt'] as int?,
        sunrise: data['sunrise'] as int?,
        sunset: data['sunset'] as int?,
        temp: (data['temp'] as num?)?.toDouble(),
        feelsLike: (data['feels_like'] as num?)?.toDouble(),
        pressure: data['pressure'] as int?,
        humidity: data['humidity'] as int?,
        dewPoint: (data['dew_point'] as num?)?.toDouble(),
        uvi: data['uvi'] as int?,
        clouds: data['clouds'] as int?,
        visibility: data['visibility'] as int?,
        windSpeed: (data['wind_speed'] as num?)?.toDouble(),
        windDeg: data['wind_deg'] as int?,
        windGust: (data['wind_gust'] as num?)?.toDouble(),
        weather: (data['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromFrom(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toFrom() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'wind_gust': windGust,
        'weather': weather?.map((e) => e.toFrom()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Current].
  factory Current.fromJson(String data) {
    return Current.fromFrom(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Current] to a JSON string.
  String toJson() => json.encode(toFrom());
}
