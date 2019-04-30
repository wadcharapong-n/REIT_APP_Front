import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/interceptor.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/models/user.dart';


class ProfileService {
Future<User> getProfileData() async {
  final httpClient = new CustomHttpClient();
  final response = await httpClient.get(AppConfig.apiUrl + '/profile');

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } 
  else {
    throw Exception('Failed to load data');
  }
}
}