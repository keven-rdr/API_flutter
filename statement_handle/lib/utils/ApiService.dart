import 'dart:convert';
import 'package:http/http.dart' as http;

enum HttpVerb { get, post, put, delete }

class ApiResponse<T> {
  final T? data;
  final int statusCode; //se o code vinher com error não mexe com data por isso que ele pode ser null

  ApiResponse({
    required this.data,
    required this.statusCode,

  });
}

class ApiService { //Static não precisa do metodo para instanciar
  static Future<ApiResponse<T>> request<T>({ //Future app não vai esperar o Future terminar para seguir. Pode colocar um item de load
    required String url,
    required HttpVerb verb,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    required T Function(dynamic json) fromJson,
  }) async {
    http.Response? response;
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    try {
      switch (verb) {
        case HttpVerb.get:
          response = await http.get(Uri.parse(url), headers: defaultHeaders);//Não preceisa esperar(await)
          break;
        case HttpVerb.post:
          response = await http.post(
            Uri.parse(url),
            headers: defaultHeaders,
            body: jsonEncode(body),
          );
          break;
        case HttpVerb.put:
          response = await http.put(
            Uri.parse(url),
            headers: defaultHeaders,
            body: jsonEncode(body),
          );
          break;
        case HttpVerb.delete:
          response = await http.delete(
            Uri.parse(url),
            headers: defaultHeaders,
            body: jsonEncode(body),
          );
          break;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final data = fromJson(decoded);
        return ApiResponse<T>(
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<T>(
          data: null,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        data: null,
        statusCode: 500,
      );
    }
  }
}