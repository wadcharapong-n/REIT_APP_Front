
import 'dart:async';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:reit_app/app_config.dart';
// import 'package:reit_app/app_config.dart';

class CustomHttpClient extends IOClient {
  CustomHttpClient() : super();
  static String token = "Basic "+AppConfig.token;
  // static String token = "Bearer " + AppConfig.token;

  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    HttpHeaders.authorizationHeader: token
  };

  @override
  Future<StreamedResponse> send(BaseRequest request) async{
    return super.send(request..headers.addAll(_headers));
  }

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) {
    return super.head(url, headers: headers..addAll(_headers));
  }

  @override
  Future<Response> get(Object url, {Map<String, String> headers}) {
    return super.get(url, headers: (headers ?? _headers)..addAll(_headers));
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