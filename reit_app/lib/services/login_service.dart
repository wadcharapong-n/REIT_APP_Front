import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/interceptor.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/functions/save_token.dart';

bool _isSuccess;
Future getToken(String token, String site) async {
  final httpClient = new CustomHttpClient();
  final response = await httpClient.get(
      AppConfig.authApiUrl + "?token=" + token + "&site=" + site,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    _isSuccess = true;

    Map<String, dynamic> newToken = jsonDecode(response.body);
    saveToken(token: newToken['token']).then((onValue) {
      AppConfig.token = newToken['token'];
    });

    return _isSuccess;
  } else {
    throw Exception('Login fail');
  }
}
