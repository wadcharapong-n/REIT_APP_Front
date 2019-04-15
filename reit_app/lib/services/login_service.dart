import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/services/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

Future getToken(String token, String site) async {
  final response = await http.get(
      AppConfig.authApiUrl + "?token=" + token + "&site=" + site,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    Map<String, dynamic> newToken = jsonDecode(response.body);
    print('-------->Token');
    print(newToken['token']);
    saveToken(newToken['token']);

    return true;
  } else {
    throw Exception('Login fail');
  }
}
