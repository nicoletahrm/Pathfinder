import 'dart:convert';

class Temp {
  double? day;
  double? max;
  double? night;

  Temp({this.day, this.max, this.night});

  @override
  String toString() {
    return 'Temp(day: $day)';
  }

  factory Temp.fromJson(Map<String, dynamic> data) => Temp(
        day: (data['day'] as num?)?.toDouble(),
        max: (data['max'] as num?)?.toDouble(),
        night: (data['night'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {'day': day};

  /// Parses the string and returns the resulting Json object as [Temp].
  factory Temp.froomJson(String data) {
    return Temp.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  /// Converts [Temp] to a JSON string.
  String tooJson() => json.encode(toJson());
}
