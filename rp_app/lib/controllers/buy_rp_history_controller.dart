import 'package:get/get.dart';
import '../models/buy_rp_model.dart';
import '../services/rp_service.dart';

class BuyRPHistoryController extends GetxController {
  final RPService _rpService = RPService();

  var isLoading = true.obs;
  var history = <BuyRPModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      final data = await _rpService.getBuyRPHistory();
      history.assignAll(data);
    } catch (e) {
      print("❌ Buy RP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
