import 'dart:developer';
import '../services/api_service.dart';
import '../models/bank_model.dart';

class BankService {
  final ApiService _api = ApiService();

  Future<List<BankAccount>> getBanks() async {
    log("🏦 BankService: Fetching bank list...");

    final res = await _api.get(
      "/bank/list",
      useCache: true,
      cacheMaxAge: const Duration(minutes: 2), // Cache for 2 minutes
    );

    final banks = (res['data'] as List)
        .map((e) => BankAccount.fromJson(e))
        .toList();

    log("🏦 BankService: Fetched ${banks.length} banks");

    return banks;
  }

  Future<void> addBank(Map<String, dynamic> body) async {
    log("🏦 BankService: Adding bank - ${body['bank_name']}");
    log("📤 Request body: $body");

    final res = await _api.post("/bank/add", body);

    log("✅ BankService: Bank added successfully");
    log("📥 Response: $res");
  }

  Future<void> updateBank(String id, Map<String, dynamic> body) async {
    log("🏦 BankService: Updating bank ID: $id");
    log("📤 Request body: $body");

    final res = await _api.put("/bank/update/$id", body);

    log("✅ BankService: Bank updated successfully");
    log("📥 Response: $res");
  }

  Future<void> deleteBank(String id) async {
    log("🏦 BankService: Deleting bank ID: $id");

    final res = await _api.delete("/bank/delete/$id");

    log("✅ BankService: Bank deleted successfully");
    log("📥 Response: $res");
  }
}
