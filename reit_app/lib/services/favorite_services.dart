import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/reit_favorite.dart';
import 'package:http/http.dart' as http;
import 'package:reit_app/app_config.dart';

Future<List<ReitFavorite>> getReitFavoriteByUserId(String userId) async {
  final response =
      await http.get(AppConfig.apiUrl + "/reitFavorite/" + userId, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if (response.statusCode == 200) {
    List<ReitFavorite> allReitFavorite = List();
    json.decode(response.body).forEach((reitFavorite) {
      allReitFavorite.add(ReitFavorite.fromJson(reitFavorite));
    });

    return allReitFavorite;
  } else {
    throw Exception('Failed to load data');
  }
}
