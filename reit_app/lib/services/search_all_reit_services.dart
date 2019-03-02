import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:reit_app/models/search_all_reit.dart';

final List dataAllReit = List();

Future<String> _loadReitAsset() async {
  return await rootBundle.loadString('lib/json/reit.json');
}

Future loadReit() async {
  String jsonReitAll = await _loadReitAsset();
  final jsonResponse = json.decode(jsonReitAll);
  jsonResponse.forEach((v) {
    final reitFormJson = SearchAllReit.fromJson(v);
    dataAllReit.add(reitFormJson);
  });
}
