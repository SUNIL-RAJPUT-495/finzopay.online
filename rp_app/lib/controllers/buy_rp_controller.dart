import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/buy_rp_plan_model.dart';
import '../services/rp_service.dart';

class BuyRPController extends GetxController {
  final RPService _rpService = RPService();

  /// 🔑 Payment tracking
  String? lastOrderId;

  /// STATES
  var isLoading = true.obs;
  var isPaying = false.obs;

  /// DATA
  var plans = <BuyRPPlanModel>[].obs;
  WalletModel? wallet;

  /// UPI/QR DETAILS
  var upiId = "".obs;
  var qrImage = "".obs;

  /// UI
  var selectedIndex = 0.obs;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController utrController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // loadPlans();
  }

  // ================= LOAD PLANS + WALLET + UPI DETAILS =================
  Future<void> loadPlans() async {
    try {
      isLoading.value = true;

      // Load UPI Details first
      try {
        final upiDetails = await _rpService.getUpiDetails();
        upiId.value = upiDetails.upiId;
        qrImage.value = upiDetails.qrImage;
      } catch (e) {
        debugPrint("Failed to load UPI details: $e");
      }

      final result = await _rpService.getBuyRPPlans();
      plans.assignAll(result.$1);
      wallet = result.$2;

      if (plans.isNotEmpty) {
        selectedIndex.value = 0;
        amountController.text = plans.first.price.toString();
      }
    } catch (e) {
      debugPrint("LOAD PLANS ERROR: $e");
      Get.snackbar("Error", "Failed to load RP plans: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SELECT PLAN =================
  void selectPlan(int index) {
    if (index < 0 || index >= plans.length) return;

    selectedIndex.value = index;
    amountController.text = plans[index].price.toString();
  }

  // ================= COMMISSION TEXT =================
  String commissionText() {
    if (plans.isEmpty) return "";

    final plan = plans[selectedIndex.value];
    final commission = (plan.rpAmount * plan.commissionPercent) / 100;
    final total = plan.rpAmount + commission;

    return "If you buy ${plan.rpAmount} RP, you will get ${total.toInt()} RP";
  }

  // ================= SUBMIT UTR PAYMENT =================
  Future<void> submitUtrPayment() async {
    final utr = utrController.text.trim();
    if (utr.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a Transaction UTR ID",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (utr.length < 10) {
      Get.snackbar(
        "Error",
        "Please enter a valid Transaction UTR ID (min 10 characters)",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (plans.isEmpty) {
      Get.snackbar("Error", "Plans not loaded yet");
      return;
    }

    try {
      isPaying.value = true;
      final plan = plans[selectedIndex.value];

      final res = await _rpService.submitBuyRPRequest(
        planId: plan.id,
        paymentId: utr,
        amount: plan.price,
      );

      if (res['success'] == true) {
        utrController.clear();
        Get.snackbar(
          "Request Submitted 🎉",
          "Your transaction is submitted. Waiting for admin approval.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadPlans();
      } else {
        Get.snackbar(
          "Error",
          res['message'] ?? "Submission failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPaying.value = false;
    }
  }

  // ================= START PAYMENT (COMMENTED OUT / DEPRECATED) =================
  Future<void> startPayment() async {
    // Deprecated in favor of manual UTR payment
  }

  // ================= AFTER APP RESUME (COMMENTED OUT / DEPRECATED) =================
  Future<void> refreshAfterPayment() async {
    // Deprecated in favor of manual UTR payment
  }
}
