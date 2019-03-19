import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/reit.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

Future<List<Reit>> getReitAll() async {
  final List<Reit> reitAll = List();
  final httpClient = new CustomHttpClient();
  final response = await httpClient.get(AppConfig.apiUrl + "/reit");
  if (response.statusCode == 200) {
    json.decode(response.body).forEach((reit) {
      reitAll.add(Reit.fromJson(reit));
    });

    return reitAll;
  } else {
    throw Exception('Failed to load data');
  }
}
