import 'dart:convert';

class Minutely {
  int? dt;
  int? precipitation;

  Minutely({this.dt, this.precipitation});

  @override
  String toString() => 'Minutely(dt: $dt, precipitation: $precipitation)';

  factory Minutely.fromFrom(Map<String, dynamic> data) => Minutely(
        dt: data['dt'] as int?,
        precipitation: data['precipitation'] as int?,
      );

  Map<String, dynamic> toFrom() => {
        'dt': dt,
        'precipitation': precipitation,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Minutely].
  factory Minutely.fromJson(String data) {
    return Minutely.fromFrom(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Minutely] to a JSON string.
  String toJson() => json.encode(toFrom());
}
