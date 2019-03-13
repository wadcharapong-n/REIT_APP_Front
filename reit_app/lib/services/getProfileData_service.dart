import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/interceptor.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/functions/save_user_login.dart';
import 'package:reit_app/models/user.dart';

import 'package:http/http.dart' as http;

Future getProfileData() async {
  final httpClient = new CustomHttpClient();
  final response =
      await httpClient.get(AppConfig.apiUrl + '/profile', headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  // final Map<String, String> _headers = {
  //   'Content-type': 'application/json',
  //   'Accept': 'application/json',
  //   'Authorization':
  //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6IjE5NzUwNjY3OTI3ODgxNzgiLCJOYW1lIjoiTm9rIEZseSIsIlNpdGUiOiJmYWNlYm9vayIsImV4cCI6MTU1MjM5ODc0OH0.Suinvqpu8768P6xpoJ82g-Ra4ebgllks3pz883LJFbg'
  // };

  // final response = await http.get(
  //   "http://10.0.2.2:1323/api/profile",
  //   headers: _headers,
  // );

  if (response.statusCode == 200) {
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      throw Exception('Fail');
  } else {
    print('ooooooooooooooooooooooooooooooooooooooo');
    throw Exception('Fail');
  }
}
