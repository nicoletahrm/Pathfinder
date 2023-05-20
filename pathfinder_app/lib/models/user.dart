class User {
  final String username;
  final String email;
  final String profilePhoto;

  User(
      {required this.username,
      required this.email,
      required this.profilePhoto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
    );
  }
}
