import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getToken = preferences.getString("LastToken");
  return getToken;
}
