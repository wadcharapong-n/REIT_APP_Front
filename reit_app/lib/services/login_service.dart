import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/interceptor.dart';
import 'package:reit_app/app_config.dart';

bool _isSuccess;
Future getToken(String token, String site) async {
  final httpClient = new CustomHttpClient();
  final response = await httpClient.get(
      "http://127.0.0.1:1323/Auth?token=" + token + "&site=" + site,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    _isSuccess = true;
    AppConfig.token = json.decode(response.body);
    return _isSuccess;
  } else {
    throw Exception('Login fail');
  }
}
