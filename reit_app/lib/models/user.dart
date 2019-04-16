class User {
  final String userID;
  final String userName;
  final String fullName;
  final String email;
  final String image;
  final String site;

  const User({
    this.userID,
    this.userName,
    this.fullName,
    this.email,
    this.image,
    this.site,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      image: json['image'],
      site: json['site'],
    );
  }
}
