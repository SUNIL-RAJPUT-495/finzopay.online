import 'package:get/get.dart';
import '../models/home_model.dart';
import '../services/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  var isLoading = true.obs;
  var homeData = Rxn<HomeModel>();
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchHome();
  }

  Future<void> fetchHome() async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _homeService.getHomeData();
      homeData.value = data;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
