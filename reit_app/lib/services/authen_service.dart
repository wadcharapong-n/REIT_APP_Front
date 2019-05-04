import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/services/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class AuthenService  {
  final sharedPreferencesService = Injector.getInjector().get<SharedPreferencesService>();

  Future getAccessToken(String token, String site) async {
  final response = await http.get(
      AppConfig.authApiUrl + "?token=" + token + "&site=" + site,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    Map<String, dynamic> newToken = jsonDecode(response.body);
    sharedPreferencesService.saveToken(newToken['token']);
    sharedPreferencesService.saveRefreshToken(newToken['refreshToken']);
    print(newToken['token']);
    return true;
  } else {
    throw Exception('Login fail');
  }
}

  Future resfrehToken() async {
    final response = await http.get(AppConfig.apiUrl + "/refreshToken",
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer " + await sharedPreferencesService.getRefreshToken()
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> newToken = jsonDecode(response.body);
      sharedPreferencesService.saveToken(newToken['token']);
    } 
    return response;
  }

  LogoutAndNavigateToLogin(BuildContext context) {
    sharedPreferencesService.saveLogout().then((_) {
      Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
    });
  }
}
