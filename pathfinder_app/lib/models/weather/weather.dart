import 'dart:convert';
import 'current.dart';
import 'daily.dart';

class Weather {
  double? lat;
  double? lon;
  String? timezone;
  int? timezoneOffset;
  Current? current;
  List<Daily>? daily;

  Weather({
    this.lat,
    this.lon,
    this.timezone,
    this.timezoneOffset,
    this.current,
    this.daily,
  });

  @override
  String toString() {
    return 'Weather(lat: $lat, lon: $lon, timezone: $timezone, timezoneOffset: $timezoneOffset, current: $current, daily: $daily)';
  }

  factory Weather.fromFrom(Map<String, dynamic> data) => Weather(
        lat: (data['lat'] as num?)?.toDouble(),
        lon: (data['lon'] as num?)?.toDouble(),
        timezone: data['timezone'] as String?,
        timezoneOffset: data['timezone_offset'] as int?,
        current: data['current'] == null
            ? null
            : Current.fromFrom(data['current'] as Map<String, dynamic>),
        daily: (data['daily'] as List<dynamic>?)
            ?.map((e) => Daily.fromFrom(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toFrom() => {
        'lat': lat,
        'lon': lon,
        'timezone': timezone,
        'timezone_offset': timezoneOffset,
        'current': current?.toFrom(),
        'daily': daily?.map((e) => e.toFrom()).toList(),
      };

  /// Parses the string and returns the resulting Json object as [Weather].
  factory Weather.fromJson(String data) {
    return Weather.fromFrom(json.decode(data) as Map<String, dynamic>);
  }

  /// Converts [Weather] to a JSON string.
  String toJson() => json.encode(toFrom());
}
