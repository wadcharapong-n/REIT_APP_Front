import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:reit_app/services/authen_service.dart';
import 'dart:io';
import 'package:reit_app/services/shared_preferences_service.dart';

class CustomHttpClient extends IOClient {
  final sharedPreferencesService =
      Injector.getInjector().get<SharedPreferencesService>();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  CustomHttpClient() : super();

  Future<Map<String, String>> getHeader() async {
    var token = await sharedPreferencesService.getToken();
    final Map<String, String> _headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer " + token,
    };
    return _headers;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    var response = super.send(request..headers.addAll(await getHeader()));
    return response;
  }

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) async {
    return super.head(url, headers: headers..addAll(await getHeader()));
  }

  @override
  Future<Response> get(Object url, {Map<String, String> headers}) async {
    var response = await super.get(url,
        headers: (headers ?? await getHeader())..addAll(await getHeader()));

    if (response.statusCode == 401) {
      var refreshToken = await new AuthenService().resfrehToken();
      if (refreshToken.statusCode == 200) {
        response = await super.get(url,
            headers: (headers ?? await getHeader())..addAll(await getHeader()));
      }
    }
    return response;
  }
}

class CustomMultipartRequest extends MultipartRequest {
  CustomHttpClient client = CustomHttpClient();
  CustomMultipartRequest(String method, Uri uri) : super(method, uri);

  void close() => client.close();

  @override
  Future<StreamedResponse> send() async {
    try {
      var response = await client.send(this);
      if (response.statusCode == 401) {
        var refreshToken = await new AuthenService().resfrehToken();
        if (refreshToken.statusCode == 200) {
          response = await client.send(this);
        } else {}
      }
      var stream = onDone(response.stream, client.close);

      return new StreamedResponse(
        new ByteStream(stream),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (_) {
      client.close();
      rethrow;
    }
  }

  Stream<T> onDone<T>(Stream<T> stream, void onDone()) =>
      stream.transform(new StreamTransformer.fromHandlers(handleDone: (sink) {
        sink.close();
        onDone();
      }));
}
