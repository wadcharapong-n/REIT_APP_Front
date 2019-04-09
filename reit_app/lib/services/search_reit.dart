import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

Future<List<ReitDetail>> getReitQuery(query) async {
  final List<ReitDetail> reitAll = List();
  final httpClient = new CustomHttpClient();
  final response =
      await httpClient.get(AppConfig.apiUrl + "/search?query=" + query);
  if (response.statusCode == 200) {
    if (json.decode(response.body) != null) {
      json.decode(response.body).forEach((reit) {
        reitAll.add(ReitDetail.fromJson(reit));
      });
    }
  }
  return reitAll;
}
