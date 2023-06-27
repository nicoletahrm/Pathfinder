class RouteRequest {
  final String id;
  final String trailId;
  final String filePath;
  final String route;
  final String sign;
  late final bool isAccepted;

  RouteRequest({
    required this.id,
    required this.trailId,
    required this.filePath,
    required this.route,
    required this.sign,
    required this.isAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "trailId": trailId,
      "filePath": filePath,
      "route": route,
      "sign": sign,
      "isAccepted": isAccepted,
    };
  }

  factory RouteRequest.fromJson(Map<String, dynamic> json) {
    final data = json;

    return RouteRequest(
      id: data["id"],
      trailId: data["trailId"],
      filePath: data["filePath"],
      route: data["route"],
      sign: data["sign"],
      isAccepted: data["isAccepted"],
    );
  }
}
