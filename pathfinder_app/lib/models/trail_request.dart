class TrailRequest {
  final String title;
  final String file;
  final String sign;
  final bool isAccepted;

  TrailRequest({
    required this.title,
    required this.file,
    required this.sign,
    required this.isAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "file": file,
      "sign": sign,
      "isAccepted": isAccepted,
    };
  }

  factory TrailRequest.fromJson(Map<String, dynamic> json) {
    final data = json;

    return TrailRequest(
      title: data["title"],
      file: data["file"],
      sign: data["sign"],
      isAccepted: data["isAccepted"],
    );
  }
}
