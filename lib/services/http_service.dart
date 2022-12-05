import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'http_helper.dart';

class HttpService {
  static bool isTester = true;
  static String SERVER_DEVELOPMENT = "jsonplaceholder.typicode.com";
  static String SERVER_PRODUCTION = "jsonplaceholder.typicode.com";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.get(uri);
      _returnResponse(response);
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api);
      var response = await client.post(uri, body: jsonEncode(params));
      _returnResponse(response);
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api);
      var response = await client.put(uri, body: jsonEncode(params));
      _returnResponse(response);
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.delete(uri);
      _returnResponse(response);
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static _returnResponse(Response response) {
    String responseJson = response.body;
    final jsonResponse = jsonDecode(responseJson);
    switch (response.statusCode) {
      case 200:
        return jsonResponse;
      case 400:
        throw BadRequestException(jsonResponse['message']);
      case 401:
        throw InvalidInputException(jsonResponse['message']);
      case 403:
        throw UnauthorisedException(jsonResponse['message']);
      case 404:
        throw FetchDataException(jsonResponse['message']);
      case 500:
      default:
        throw FetchDataException(jsonResponse['message']);
    }
  }

  /* Http Apis */
  static String API_POST_LIST = "/postss";
  static String API_REFRESH_TOKEN = "/refresh";

  /* Http Params */

  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }
}
