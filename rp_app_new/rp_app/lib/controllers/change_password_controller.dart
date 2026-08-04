import 'dart:developer';

import 'package:get/get.dart';
import '../services/auth_service.dart';

class ChangePasswordController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive states
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Change password for logged-in user
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      log("✅ Password changed successfully");
      return true;
    } catch (e, stk) {
      errorMessage.value = e.toString();
      log("❌ Error changing password: $e, $stk");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
