class TrailRequest {
  final String title;
  final String source;
  final String sign;
  final String filePath;
  final bool isAccepted;

  TrailRequest({
    required this.title,
    required this.source,
    required this.sign,
    required this.filePath,
    required this.isAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "source": source,
      "sign": sign,
      "filePath": filePath,
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
      isAccepted: data["isAccepted"],
    );
  }
}
