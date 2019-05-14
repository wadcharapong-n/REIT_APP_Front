import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reit_app/models/user.dart';
import 'package:reit_app/utils/shared_preferences_config.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SharedPreferencesService {
  var facebookLogin = FacebookLogin();
  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String getToken = preferences.getString(SharedPreferencesConfig.token);
    return getToken;
  }

  Future<String> getRefreshToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String getToken =
        preferences.getString(SharedPreferencesConfig.refreshToken);
    return getToken;
  }

  Future<User> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userId = preferences.getString(SharedPreferencesConfig.userId);
    String userName = preferences.getString(SharedPreferencesConfig.userName);
    String fullName = preferences.getString(SharedPreferencesConfig.fullName);
    String email = preferences.getString(SharedPreferencesConfig.email);
    String image = preferences.getString(SharedPreferencesConfig.image);
    String site = preferences.getString(SharedPreferencesConfig.site);

    User user = User(
        userID: userId,
        userName: userName,
        fullName: fullName,
        email: email,
        image: image,
        site: site);

    return user;
  }

  Future saveLogout() async {
    await facebookLogin.logOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Future saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (token != null) {
      await preferences.setString(SharedPreferencesConfig.token, token);
    }
  }

  Future saveRefreshToken(String refreshToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (refreshToken != null) {
      await preferences.setString(
          SharedPreferencesConfig.refreshToken, refreshToken);
    }
  }
}
