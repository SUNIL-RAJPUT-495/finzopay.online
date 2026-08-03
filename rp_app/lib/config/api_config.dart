class ApiConfig {
  // static const String baseUrl = "http://localhost:8000/api/v1/mobile";
  static const String baseUrl = "https://api.finzopay.online/api/v1/mobile";

  static Map<String, String> headers({String? token}) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
    };
  }
}
