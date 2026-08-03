import 'package:http/http.dart';

import '../services/api_service.dart';
import '../models/bank_model.dart';

class BankService {
  final ApiService _api = ApiService();

  Future<List<BankAccount>> getBanks() async {
    final res = await _api.get("/bank/list");
    return (res['data'] as List).map((e) => BankAccount.fromJson(e)).toList();
  }

  Future<void> addBank(Map<String, dynamic> body) async {
    await _api.post("/bank/add", body);
  }

  Future<void> updateBank(String id, Map<String, dynamic> body) async {
    await _api.put("/bank/update/$id", body);
  }

  Future<void> deleteBank(String id) async {
    await _api.delete("/bank/delete/$id");
  }
}
