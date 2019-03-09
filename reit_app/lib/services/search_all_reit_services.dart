import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/reit.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

final List<Reit> reitAll = List();

Future getReitAll() async {
  final httpClient = new CustomHttpClient();
  final response = await httpClient.get(AppConfig.apiUrl + "/reit", headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if (response.statusCode == 200) {
    json.decode(response.body).forEach((reit) {
      reitAll.add(Reit.fromJson(reit));
    });
  } else {
    throw Exception('Failed to load data');
  }
}
