import 'dart:async' show Future;
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

Future<String> getSyncReit() async {
  final httpClient = new CustomHttpClient();
  final response = await httpClient.get(AppConfig.apiUrl + "/syncElastic");
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}
