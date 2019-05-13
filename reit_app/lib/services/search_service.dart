import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/interceptor.dart';

class SearchService {
  Future<List> reitSearch(String searchText) async {
    List reitsDetail = List();
    await getReitQuery(searchText).then((result) {
      reitsDetail = result;
    });

    return reitsDetail;
  }

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

  Future<List<ReitDetail>> getReitAll() async {
    final httpClient = new CustomHttpClient();
    final response = await httpClient.get(AppConfig.apiUrl + "/reit");
    List<ReitDetail> reitAll = List();
    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        json.decode(response.body).forEach((reit) {
          reitAll.add(ReitDetail.fromJson(reit));
        });
      }
    } else if (response.statusCode == 401) {
      throw Exception('Failed to load data, Unauthorized');
    }
    return reitAll;
  }
}
