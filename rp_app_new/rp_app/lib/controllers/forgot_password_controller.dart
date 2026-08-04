import 'dart:developer';

import 'package:get/get.dart';
import '../services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive states
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentStep = 0.obs; // 0 = enter phone, 1 = enter OTP & new password

  // Form data
  var phone = ''.obs;

  /// STEP 1: Send OTP for forgot password
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.sendForgotPasswordOtp(phone: phoneNumber);

      phone.value = phoneNumber;
      currentStep.value = 1; // Move to OTP verification step

      log("✅ Forgot password OTP sent successfully");
      return true;
    } catch (e, stk) {
      errorMessage.value = e.toString();
      log("❌ Error sending forgot password OTP: $e, $stk");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// STEP 2: Reset password with OTP
  Future<bool> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.resetPassword(
        phone: phone.value,
        otp: otp,
        newPassword: newPassword,
      );

      log("✅ Password reset successfully");
      return true;
    } catch (e, stk) {
      errorMessage.value = e.toString();
      log("❌ Error resetting password: $e, $stk");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset controller state
  void resetState() {
    currentStep.value = 0;
    phone.value = '';
    errorMessage.value = '';
  }
}
