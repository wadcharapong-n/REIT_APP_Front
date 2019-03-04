
import 'dart:async';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';

class CustomHttpClient extends IOClient {
  CustomHttpClient() : super();

  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    HttpHeaders.authorizationHeader: "Basic 23ftrwtdrwe23tydretyr2tyerty2rety"
  };

  @override
  Future<StreamedResponse> send(BaseRequest request) async{
    print("request >> send");
    return super.send(request..headers.addAll(_headers));
  }

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) {
    print("request >> head");
    return super.head(url, headers: headers..addAll(_headers));
  }

  @override
  Future<Response> get(Object url, {Map<String, String> headers}) {
    print("request >> get");
    return super.get(url, headers: (headers ?? _headers)..addAll(_headers));
  }

}