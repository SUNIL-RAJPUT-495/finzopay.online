import 'dart:developer';

import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // reactive states
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// SEND OTP (Login)
  Future<bool> sendOtp({
    required String phone,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.sendOtp(
        phone: phone,
        password: password,
      );

      return true;
    } catch (e,stk) {
      errorMessage.value = e.toString();
      log("Exception: $e, $stk");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
