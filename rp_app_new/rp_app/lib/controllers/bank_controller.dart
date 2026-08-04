import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/home_controller.dart';
import '../models/bank_model.dart';
import '../services/bank_service.dart';
import '../services/api_service.dart';

class ManageBankController extends GetxController {
  final BankService _service = BankService();
  final ApiService _apiService = ApiService();

  final isLoading = true.obs;
  final banks = <BankAccount>[].obs;

  @override
  void onInit() {
    super.onInit();
    log("🏦 ManageBankController initialized");
    loadBanks();
  }

  Future<void> loadBanks() async {
    try {
      log("🔄 Loading banks...");
      isLoading.value = true;

      final result = await _service.getBanks();
      banks.assignAll(result);

      log("✅ Loaded ${result.length} banks successfully");
      log("📋 Banks: ${result.map((b) => b.bankName).toList()}");
    } catch (e) {
      log("❌ Error loading banks: $e");
      Get.snackbar(
        "Error",
        "Failed to load bank accounts: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBank(Map<String, dynamic> data) async {
    try {
      log("➕ Adding new bank: ${data['bank_name']}");

      await _service.addBank(data);

      log("✅ Bank added successfully");

      // Clear cache to force fresh data
      _apiService.clearCacheEntry("/bank/list");
      log("🗑️ Cleared bank list cache");

      // Reload banks
      await loadBanks();

      // Refresh home page to show updated bank count
      _refreshHome();

      Get.snackbar(
        "Success",
        "Bank account added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
      );
    } catch (e) {
      log("❌ Error adding bank: $e");
      Get.snackbar(
        "Error",
        "Failed to add bank: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
      rethrow;
    }
  }

  Future<void> updateBank(String id, Map<String, dynamic> data) async {
    try {
      log("✏️ Updating bank ID: $id");
      log("📝 Update data: ${data['bank_name']}");

      await _service.updateBank(id, data);

      log("✅ Bank updated successfully");

      // Clear cache to force fresh data
      _apiService.clearCacheEntry("/bank/list");
      log("🗑️ Cleared bank list cache");

      // Reload banks
      await loadBanks();

      // Refresh home page to show updated bank info
      _refreshHome();

      Get.snackbar(
        "Success",
        "Bank account updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
      );
    } catch (e) {
      log("❌ Error updating bank: $e");
      Get.snackbar(
        "Error",
        "Failed to update bank: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
      rethrow;
    }
  }

  Future<void> deleteBank(String id) async {
    try {
      log("🗑️ Deleting bank ID: $id");

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Delete Bank Account"),
          content: const Text(
            "Are you sure you want to delete this bank account?",
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
              child: const Text("Delete"),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        log("❌ Delete cancelled by user");
        return;
      }

      await _service.deleteBank(id);

      log("✅ Bank deleted successfully");

      // Clear cache to force fresh data
      _apiService.clearCacheEntry("/bank/list");
      log("🗑️ Cleared bank list cache");

      // Reload banks
      await loadBanks();

      // Refresh home page to show updated bank count
      _refreshHome();

      Get.snackbar(
        "Success",
        "Bank account deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
      );
    } catch (e) {
      log("❌ Error deleting bank: $e");
      Get.snackbar(
        "Error",
        "Failed to delete bank: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
      rethrow;
    }
  }

  /// Refresh home page data after bank changes
  void _refreshHome() {
    try {
      log("🔄 Attempting to refresh home page...");

      // Clear home cache to force fresh data
      _apiService.clearCacheEntry("/home");
      log("🗑️ Cleared home cache");

      // Check if HomeController exists before trying to use it
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.fetchHome();
        log("✅ Home page refreshed successfully");
      } else {
        log("⚠️ HomeController not registered, skipping refresh");
      }
    } catch (e) {
      log("❌ Error refreshing home: $e");
      // Don't throw error, just log it - home refresh is not critical
    }
  }
}
