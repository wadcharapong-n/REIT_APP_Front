import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/services/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

Future getAccessToken(String token, String site) async {
  final response = await http.get(
      AppConfig.authApiUrl + "?token=" + token + "&site=" + site,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    Map<String, dynamic> newToken = jsonDecode(response.body);
    saveToken(newToken['token']);
    saveRefreshToken(newToken['refreshToken']);
    return true;
  } else {
    throw Exception('Login fail');
  }
}

class LoginService {
  Future resfrehToken() async {
    final response = await http.get(AppConfig.apiUrl + "/refreshToken",
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer " + await getRefreshToken()
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> newToken = jsonDecode(response.body);
      saveToken(newToken['token']);
      return response;
    } else {
      throw Exception('Failed to Resfreh Token');
    } 
  }
}
