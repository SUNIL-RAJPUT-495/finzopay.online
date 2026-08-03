import 'package:get/get.dart';
import '../models/bank_model.dart';
import '../services/bank_service.dart';

class ManageBankController extends GetxController {
  final BankService _service = BankService();

  final isLoading = true.obs;
  final banks = <BankAccount>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBanks();
  }

  Future<void> loadBanks() async {
    try {
      isLoading.value = true;
      final result = await _service.getBanks();
      banks.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBank(Map<String, dynamic> data) async {
    await _service.addBank(data);
    await loadBanks();
  }

  Future<void> updateBank(String id, Map<String, dynamic> data) async {
    await _service.updateBank(id, data);
    await loadBanks();
  }

  Future<void> deleteBank(String id) async {
    await _service.deleteBank(id);
    await loadBanks();
  }
}
