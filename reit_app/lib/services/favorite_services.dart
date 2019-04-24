import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/favorite_reit.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

class FavoriteService {
  Future<bool> isFavoriteReit(String symbol) async {
    bool isFavoriteReit = false;
    await getFavoriteReitByUserId().then((result) {
      if (!(result.isEmpty)) {
        for (var favoriteReit in result) {
          if (favoriteReit.symbol == symbol) {
            isFavoriteReit = true;
          } 
          // else {
          //   isFavoriteReit = false;
          // }
        }
      } else {
        isFavoriteReit = false;
      }
    });
    return isFavoriteReit;
  }

  Future<List<FavoriteReit>> getFavoriteReitByUserId() async {
    final httpClient = new CustomHttpClient();
    final response = await httpClient.get(AppConfig.apiUrl + "/reitFavorite");
    if (response.statusCode == 200) {
      List<FavoriteReit> favoriteReitList = List();
      if (json.decode(response.body) != null) {
        json.decode(response.body).forEach((favoriteReit) {
          favoriteReitList.add(FavoriteReit.fromJson(favoriteReit));
        });
      }
      return favoriteReitList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future addReitFavorite(String ticker) async {
    var uri = Uri.parse(AppConfig.apiUrl + "/reitFavorite");
    var request = new CustomMultipartRequest("POST", uri);
    request.fields['Ticker'] = ticker;
    request.send().then((response) {
      if (response.statusCode == 200) {
        return 'success';
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  Future deleteReitFavorite(String ticker) async {
    var uri = Uri.parse(AppConfig.apiUrl + "/reitFavorite");
    var request = new CustomMultipartRequest("DELETE", uri);
    request.fields['Ticker'] = ticker;
    request.send().then((response) {
      if (response.statusCode == 200) {
        return 'success';
      } else {
        throw Exception('Failed to load data');
      }
    });
  }
}
