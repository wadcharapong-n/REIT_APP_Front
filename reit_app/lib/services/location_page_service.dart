import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/interceptor.dart';
import 'package:reit_app/models/place.dart';
import 'package:reit_app/app_config.dart';

class LocationPageService {
  Future<Place> getSearchAroundReit(String lat, String long) async {
    final httpClient = new CustomHttpClient();
    final response = await httpClient.get(
        AppConfig.apiUrl + "/searchMap?lat=" + lat + "&lon=" + long,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
    if (response.statusCode == 200) {
      Place.fromJson(json.decode(response.body));
    } else if(response.statusCode == 401) {
      throw Exception('Failed to load data, Unauthorized');
    } 
    return new Place();
  }
}
