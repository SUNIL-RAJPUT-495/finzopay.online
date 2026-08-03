import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/sell_page_model.dart';
import '../services/rp_service.dart';

class SellRPController extends GetxController {
  final RPService _rpService = RPService();

  // STATES
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  // DATA
  var sellData = Rxn<SellRPResponse>();
  var selectedBank = Rxn<BankAccount>();

  // INPUT
  final TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // loadSellData();
  }

  /// LOAD SELL PAGE DATA
  Future<void> loadSellData() async {
    try {
      isLoading.value = true;

      final res = await _rpService.getSellPageData();
      sellData.value = res;

      if (res.bank.hasBank && res.bank.list.isNotEmpty) {
        selectedBank.value = res.bank.list.firstWhere(
              (b) => b.isDefault,
          orElse: () => res.bank.list.first,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load Sell RP data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// SELECT BANK
  void selectBank(BankAccount bank) {
    selectedBank.value = bank;
  }

  /// SUBMIT SELL RP
  Future<void> submitSellRp() async {
    final amountText = amountController.text.trim();

    if (amountText.isEmpty) {
      _showDialog("Enter amount", "Please enter RP amount");
      return;
    }

    final amount = int.parse(amountText);
    final available = sellData.value!.balance.availableRp;

    if (amount > available) {
      _showDialog(
        "Insufficient Balance",
        "You only have $available RP available",
      );
      return;
    }

    if (selectedBank.value == null) {
      _showDialog("Bank Required", "Please select a bank");
      return;
    }

    try {
      isSubmitting.value = true;

      await _rpService.sellRp(
        rpAmount: amount,
        bankAccountId: selectedBank.value!.id,
      );

      amountController.clear();
      await loadSellData();

      _showDialog("Success", "Sell RP request submitted successfully");
    } catch (e) {
      _showDialog("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
