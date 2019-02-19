import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<String> _loadReitAsset() async {
  return await rootBundle.loadString('lib/json/reit.json');
}

Future loadReit() async {
  String jsonAddress = await _loadReitAsset();
  final jsonResponse = json.decode(jsonAddress);
  return jsonResponse;
}
