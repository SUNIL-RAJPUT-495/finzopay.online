import 'dart:developer';
import 'package:get/get.dart';
import '../models/home_model.dart';
import '../services/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  var isLoading = true.obs;
  var homeData = Rxn<HomeModel>();

  final amount = "".obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    log("🏠 HomeController initialized");
    fetchHome();
  }

  Future<void> fetchHome() async {
    try {
      log("🔄 Fetching home data...");
      isLoading.value = true;
      error.value = '';

      final data = await _homeService.getHomeData();
      homeData.value = data;
      amount.value = "₹${data.wallet.totalBalance}";
      log("✅ Home data loaded successfully");
      log(
        "📊 Bank accounts: ${data.bank?.accounts.length ?? 0}, Total balance: ${data.wallet.totalBalance}",
      );
    } catch (e) {
      log("❌ Error fetching home data: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    log("🏠 HomeController disposed");
    super.onClose();
  }
}
