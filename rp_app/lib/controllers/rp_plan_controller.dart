import 'package:get/get.dart';
import '../models/rp_plan_model.dart';
import '../services/api_service.dart';
import '../views/buy_rp_tab_screen.dart';

class RPPlanController extends GetxController {
  final ApiService _api = ApiService();

  var plans = <RPPlanModel>[].obs;
  var loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      loading.value = true;

      final res = await _api.get("/rp/plans/all");
      print("----------------");
      print(res);

      plans.value = (res['data'] as List)
          .map((e) => RPPlanModel.fromJson(e))
          .toList();

    } finally {
      loading.value = false;
    }
  }

  void buyNow(RPPlanModel plan) {
    Get.to(() => const BuyRPTabScreen(), arguments: plan.id);
  }
}
