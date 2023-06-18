class User {
  final String username;
  final String email;
  final String profilePhoto;
  //final List<String> trails;

  User(
      {required this.username,
      required this.email,
      required this.profilePhoto,
      //required this.trails
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
     // trails: List<String>.from(json['trails']),
    );
  }
}
