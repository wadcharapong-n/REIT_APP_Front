import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reit_app/models/user.dart';

Future<User> getUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String userId = preferences.getString("LastUserId");
  String userName = preferences.getString("LastUserName");
  String fullName = preferences.getString("LastFullName");
  String email = preferences.getString("LastEmail");
  String image = preferences.getString("LastImage");
  String site = preferences.getString("LastSite");

  User user = User(
      userID: userId,
      userName: userName,
      fullName: fullName,
      email: email,
      image: image,
      site: site);

  return user;
}
