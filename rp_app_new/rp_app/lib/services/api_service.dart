import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../routes/app_routes.dart';
import '../utils/api_cache.dart';
import '../utils/token_storage.dart';

class ApiService {
  // Singleton pattern for better performance
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  // Persistent HTTP client for connection pooling (reuses connections)
  static final http.Client _client = http.Client();

  // Reduced timeout duration (15 seconds instead of 30)
  static const Duration _timeoutDuration = Duration(seconds: 15);

  // Reduced retry attempts (1 instead of 2)
  static const int _maxRetries = 1;

  // Faster retry delay (500ms instead of 1s)
  static const Duration _retryDelay = Duration(milliseconds: 500);

  // Cache instance
  final ApiCache _cache = ApiCache();

  /// 🔹 GET REQUEST (with optional caching)
  Future<dynamic> get(
    String endpoint, {
    Duration? timeout,
    bool useCache = false,
    Duration? cacheMaxAge,
  }) async {
    // Check cache first if enabled
    if (useCache) {
      final cachedData = _cache.get(endpoint, maxAge: cacheMaxAge);
      if (cachedData != null) {
        log("📦 Cache HIT for: $endpoint");
        return cachedData;
      }
    }

    return _executeWithRetry(() async {
      final token = await TokenStorage.getToken();
      final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

      final response = await _client
          .get(url, headers: ApiConfig.headers(token: token))
          .timeout(
            timeout ?? _timeoutDuration,
            onTimeout: () => throw TimeoutException(
              'Request timed out. Please check your internet connection.',
            ),
          );

      final data = _handleResponse(response);

      // Cache the response if caching is enabled
      if (useCache) {
        _cache.set(endpoint, data);
        log("💾 Cached response for: $endpoint");
      }

      return data;
    });
  }

  /// 🔹 POST REQUEST
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
  }) async {
    return _executeWithRetry(() async {
      final token = await TokenStorage.getToken();
      final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

      final response = await _client
          .post(
            url,
            headers: ApiConfig.headers(token: token),
            body: jsonEncode(body),
          )
          .timeout(
            timeout ?? _timeoutDuration,
            onTimeout: () => throw TimeoutException(
              'Request timed out. Please check your internet connection.',
            ),
          );

      return _handleResponse(response);
    });
  }

  /// 🔹 PUT REQUEST
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
  }) async {
    return _executeWithRetry(() async {
      final token = await TokenStorage.getToken();
      final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

      final response = await _client
          .put(
            url,
            headers: ApiConfig.headers(token: token),
            body: jsonEncode(body),
          )
          .timeout(
            timeout ?? _timeoutDuration,
            onTimeout: () => throw TimeoutException(
              'Request timed out. Please check your internet connection.',
            ),
          );

      return _handleResponse(response);
    });
  }

  /// 🔹 DELETE REQUEST
  Future<dynamic> delete(String endpoint, {Duration? timeout}) async {
    return _executeWithRetry(() async {
      final token = await TokenStorage.getToken();
      final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

      final response = await _client
          .delete(url, headers: ApiConfig.headers(token: token))
          .timeout(
            timeout ?? _timeoutDuration,
            onTimeout: () => throw TimeoutException(
              'Request timed out. Please check your internet connection.',
            ),
          );

      return _handleResponse(response);
    });
  }

  /// 🔹 OPTIMIZED RETRY LOGIC
  Future<dynamic> _executeWithRetry(Future<dynamic> Function() request) async {
    int attempts = 0;

    while (attempts < _maxRetries) {
      try {
        return await request();
      } on TimeoutException catch (e) {
        attempts++;
        log("⏱️ Timeout on attempt $attempts: $e");

        if (attempts >= _maxRetries) {
          throw Exception(
            "Request timed out. Please check your internet connection and try again.",
          );
        }

        // Wait before retrying (reduced to 500ms)
        await Future.delayed(_retryDelay);
      } on SocketException catch (e) {
        attempts++;
        log("🌐 Network error on attempt $attempts: $e");

        if (attempts >= _maxRetries) {
          throw Exception(
            "No internet connection. Please check your network and try again.",
          );
        }

        // Wait before retrying (reduced to 500ms)
        await Future.delayed(_retryDelay);
      } catch (e) {
        // For other errors, don't retry
        rethrow;
      }
    }

    // This should never be reached, but just in case
    throw Exception("Request failed after $_maxRetries attempts");
  }

  dynamic _handleResponse(http.Response response) {
    dynamic data;

    log("✅ _handleResponse Response: Status ${response.statusCode}");
    log("✅ _handleResponse Response: Body ${response.body}");

    try {
      data = jsonDecode(response.body);
      log("✅ API Response: Status ${response.statusCode}");
    } catch (e) {
      log("❌ JSON Parse Error: $e");
      throw Exception("Invalid server response: Unable to parse response");
    }

    // ✅ HANDLE 403 HERE
    if (response.statusCode == 403) {
      String errorMessage = "Session expired. Please login again.";

      if (data is Map<String, dynamic>) {
        errorMessage =
            data["message"] ?? data["error"] ?? data["msg"] ?? errorMessage;
      }

      log("🚫 403 Forbidden: $errorMessage");

      // 🔥 Trigger logout
      _handleUnauthorized(errorMessage);

      throw Exception(errorMessage);
    }

    // ✅ SUCCESS CASE
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      String errorMessage = "Something went wrong";

      if (data is Map<String, dynamic>) {
        errorMessage =
            data["message"] ?? data["error"] ?? data["msg"] ?? errorMessage;
      }

      log("❌ API Error: $errorMessage (Status: ${response.statusCode})");
      throw Exception(errorMessage);
    }
  }

  void _handleUnauthorized(String message) async {
    try {
      log("🔐 Handling 403 - Logging out user...");

      // 1. Clear token
      await TokenStorage.clear();

      // 2. Clear cache
      _cache.clear();

      // 3. Clear GetX controllers
      Get.deleteAll(force: true);

      // 4. Navigate to login
      Get.offAllNamed(Routes.login);

      // 5. Show message
      Get.snackbar(
        "You are blocked by admin",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        duration: const Duration(seconds: 2),
      );

      log("✅ User logged out due to 403");
    } catch (e) {
      log("❌ Error in unauthorized handler: $e");
    }
  }

  /// 🔹 CACHE MANAGEMENT
  void clearCache() {
    _cache.clear();
  }

  void clearCacheEntry(String endpoint) {
    _cache.remove(endpoint);
  }

  /// 🔹 CLEANUP METHOD (call when app is disposed)
  void dispose() {
    _client.close();
  }
}
