import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:reit_app/interceptor.dart';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/app_config.dart';
// import 'package:http/http.dart' as http;

class ReitDetailService {
  Future<ReitDetail> getReitDetailBySymbol(String reitSymbol) async {
    final httpClient = new CustomHttpClient();    
    final response = await httpClient.get(AppConfig.apiUrl + "/reit/" + reitSymbol,
    // final response = await http.get('https://demo9258039.mockable.io/reit-detail',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
    if (response.statusCode == 200) {
      return ReitDetail.fromJson(json.decode(response.body));
    }
    else {
      throw Exception('Failed to load data');
    }
  }
}