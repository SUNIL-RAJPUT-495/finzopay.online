import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';
import 'package:rp_app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthService _service = AuthService();
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    log("👤 ProfileController initialized");
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      log("🔄 Loading profile...");
      isLoading.value = true;
      final res = await _service.getProfile();
      profile.value = res;
      log("✅ Profile loaded: ${res.name} (${res.phone})");
    } catch (e) {
      log("❌ Error loading profile: $e");
      Get.snackbar("Error", "Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    log("🚪 Logout initiated");

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Get.theme.colorScheme.error),
            const SizedBox(width: 12),
            const Text("Logout"),
          ],
        ),
        content: const Text(
          "Are you sure you want to logout?\n\nAll cached data will be cleared.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.error,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      log("❌ Logout cancelled by user");
      return;
    }

    try {
      log("🧹 Starting cleanup process...");

      // 1. Clear authentication token
      log("🔑 Clearing authentication token...");
      await TokenStorage.clear();

      // 2. Clear all API cache
      log("🗑️ Clearing all API cache...");
      _apiService.clearCache();

      // 3. Delete all GetX controllers to ensure fresh state
      log("🎮 Deleting all GetX controllers...");
      Get.deleteAll(force: true);

      log("✅ Cleanup completed successfully");

      // 4. Navigate to login screen and clear navigation stack
      log("🔄 Navigating to login screen...");
      Get.offAllNamed(Routes.login);

      // 5. Show success message
      Get.snackbar(
        "Logged Out",
        "You have been successfully logged out",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        duration: const Duration(seconds: 2),
      );

      log("✅ Logout completed successfully");
    } catch (e) {
      log("❌ Error during logout: $e");
      Get.snackbar(
        "Error",
        "An error occurred during logout. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
    }
  }

  @override
  void onClose() {
    log("👤 ProfileController disposed");
    super.onClose();
  }
}
