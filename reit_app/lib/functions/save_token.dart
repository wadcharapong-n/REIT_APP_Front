import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future saveToken({String token}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (token != null) {
    await preferences.setString('LastToken', token);
  }
}

Future saveRefreshToken({String refreshToken}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (refreshToken != null) {
    await preferences.setString('RefreshToken', refreshToken);
  }
}


