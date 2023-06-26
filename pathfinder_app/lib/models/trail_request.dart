import '../utils/covert.dart';

class TrailRequest {
  final String title;
  final String source;
  final String sign;
  final String filePath;
  final double altitude;
  final double distance;
  final List<dynamic> images;
  final bool isAccepted;

  TrailRequest({
    required this.title,
    required this.source,
    required this.sign,
    required this.filePath,
    required this.altitude,
    required this.distance,
    required this.images,
    required this.isAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "source": source,
      "sign": sign,
      "filePath": filePath,
      "altitude": altitude,
      "distance": distance,
      "images": images,
      "isAccepted": isAccepted,
    };
  }

  factory TrailRequest.fromJson(Map<String, dynamic> json) {
    final data = json;

    return TrailRequest(
      title: data["title"],
      source: data["source"],
      sign: data["sign"],
      filePath: data["filePath"],
      altitude: stringToDouble(data["altitude"]),
      distance: stringToDouble(data["distance"]),
      images: List<String>.from(data["images"] ?? []),
      isAccepted: data["isAccepted"],
    );
  }
}
