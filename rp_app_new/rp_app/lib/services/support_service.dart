import 'api_service.dart';

class SupportService {
  final ApiService _api = ApiService();

  Future submitSupport(Map<String, dynamic> data) async {
    return await _api.post("/support", data);
  }
}
