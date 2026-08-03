import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../utils/token_storage.dart';
import '../views/login_screen.dart';

class ProfileController extends GetxController {
  final AuthService _service = AuthService();

  var isLoading = true.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    // loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final res = await _service.getProfile();
      profile.value = res;
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    Get.offAll(() => LoginScreen());
  }
}
