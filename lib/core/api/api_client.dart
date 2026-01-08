import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? params,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: params);
    debugPrint("ApiClient uri:  $uri");
    final res = await http.get(uri).timeout(const Duration(seconds: 60));
    debugPrint("ApiClient res:  $res");
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("GET failed ${res.statusCode}");
    }
  }

  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final res = await http
        .post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));

    debugPrint("ApiClient post res:  $res");
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("POST failed ${res.statusCode}");
    }
  }
}
