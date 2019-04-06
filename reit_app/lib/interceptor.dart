
import 'dart:async';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:reit_app/services/shared_preferences_service.dart';
import 'package:reit_app/functions/get_token.dart';
import 'package:reit_app/services/login_service.dart';

class CustomHttpClient extends IOClient {
  CustomHttpClient() : super();
  
  Future<Map<String, String>> getHeader() async {
    final Map<String, String> _headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer " + await getToken(),
    };
    return _headers;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    print("------------------------- send interceptor -------------------------");
    var response = super.send(request..headers.addAll(await getHeader()));
    return response;
  }

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) async {
    print("------------------------- head interceptor -------------------------");
    return super.head(url, headers: headers..addAll(await getHeader()));
  }

  @override
  Future<Response> get(Object url, {Map<String, String> headers}) async {
    print("------------------------- get interceptor -------------------------");
    var response = await super.get(url, headers: (headers ?? await getHeader())..addAll(await getHeader()));
  
    if(response.statusCode == 401) {
      var refreshToken = await new LoginService().resfrehToken();
      if(refreshToken.statusCode == 200) {
        response = await super.get(url, headers: (headers ?? await getHeader())..addAll(await getHeader()));
      }
    }
  
    return response;
  }
}

class CustomMultipartRequest extends MultipartRequest {
  // IOClient client = IOClient(HttpClient());
  CustomHttpClient client = CustomHttpClient();
  CustomMultipartRequest(String method, Uri uri) : super(method, uri);

  void close() => client.close();

  @override
  Future<StreamedResponse> send() async {
    try {
      print("------------------------- CustomMultipartRequest -------------------------");
      var response = await client.send(this);
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