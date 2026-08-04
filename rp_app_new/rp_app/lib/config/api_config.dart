class ApiConfig {
  static const String baseUrl = "https://api.finzopay.online/api/v1/mobile";
  // static const String baseUrl = "http://192.168.1.72/api/v1/mobile";

  static Map<String, String> headers({String? token}) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }
}
