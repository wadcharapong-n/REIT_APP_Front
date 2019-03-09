import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/reit_favorite.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

Future<List<ReitFavorite>> getReitFavoriteByUserId(String userId) async {
  final httpClient = new CustomHttpClient();
  final response = await httpClient
      .get(AppConfig.apiUrl + "/reitFavorite/" + userId, headers: {
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

Future addReitFavorite(String userId, String ticker) async {
  var uri = Uri.parse(AppConfig.apiUrl + "/reitFavorite");
  var request = new CustomMultipartRequest("POST", uri);
  request.fields['userId'] = userId;
  request.fields['Ticker'] = ticker;
  request.send().then((response) {
    if (response.statusCode == 200) {
      return 'success';
    } else {
      throw Exception('Failed to load data');
    }
  });
}

Future deleteReitFavorite(String userId, String ticker) async {
  var uri = Uri.parse(AppConfig.apiUrl + "/reitFavorite");
  var request = new CustomMultipartRequest("DELETE", uri);
  request.fields['userId'] = userId;
  request.fields['Ticker'] = ticker;
  request.send().then((response) {
    if (response.statusCode == 200) {
      return 'success';
    } else {
      throw Exception('Failed to load data');
    }
  });
}
