import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../utils/token_storage.dart';

class ApiService {
  /// 🔹 GET REQUEST
  Future<dynamic> get(String endpoint) async {
    final token = await TokenStorage.getToken();

    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final response = await http.get(
      url,
      headers: ApiConfig.headers(token: token),
    );

    return _handleResponse(response);
  }

  /// 🔹 POST REQUEST
  Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final token = await TokenStorage.getToken();

    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final response = await http.post(
      url,
      headers: ApiConfig.headers(token: token),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// 🔹 PUT REQUEST
  Future<dynamic> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final response = await http.put(
      url,
      headers: ApiConfig.headers(token: token),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// 🔹 DELETE REQUEST
  Future<dynamic> delete(String endpoint) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final response = await http.delete(
      url,
      headers: ApiConfig.headers(token: token),
    );

    return _handleResponse(response);
  }

  /// 🔹 RESPONSE HANDLER (COMMON)
  dynamic _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return data;
      } else {
        throw Exception(
          data["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      throw Exception("Invalid server response");
    }
  }
}
