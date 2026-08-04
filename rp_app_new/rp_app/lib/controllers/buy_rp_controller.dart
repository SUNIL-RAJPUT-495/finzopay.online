import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/home_controller.dart';

import '../models/buy_rp_plan_model.dart';
import '../routes/app_routes.dart';
import '../services/rp_service.dart';

class BuyRPController extends GetxController with WidgetsBindingObserver {
  final RPService _rpService = RPService();

  /// 🔑 Payment tracking
  String? lastOrderId;
  bool _isProcessingPayment = false;

  /// STATES
  var isLoading = true.obs;
  var isPaying = false.obs;

  /// DATA
  var plans = <BuyRPPlanModel>[].obs;
  WalletModel? wallet;

  /// UI
  var selectedIndex = (-1).obs; // -1 = custom amount, >=0 = plan selected
  final amountController = TextEditingController();

  /// Custom amount state
  var isCustomAmount = false.obs;
  var customRpInfo = ''.obs; // live commission hint for custom amount
  var hasAmount = false.obs; // whether the text field has any content
  var amountError = ''.obs; // stores validation error message

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    amountController.addListener(_onAmountChanged);
    loadPlans();
  }

  @override
  void onClose() {
    amountController.removeListener(_onAmountChanged);
    WidgetsBinding.instance.removeObserver(this);
    amountController.dispose();
    super.onClose();
  }

  // ================= AMOUNT FIELD LISTENER =================
  void _onAmountChanged() {
    final text = amountController.text.trim();
    final typed = int.tryParse(text);

    if (typed == null || text.isEmpty) {
      isCustomAmount.value = false;
      hasAmount.value = false;
      selectedIndex.value = plans.isNotEmpty ? 0 : -1;
      customRpInfo.value = '';
      amountError.value = '';
      return;
    }

    hasAmount.value = true;

    if (typed < 100) {
      amountError.value = 'Amount must be at least ₹100';
    } else if (typed % 100 != 0) {
      amountError.value = 'Amount must be a multiple of 100';
    } else {
      amountError.value = '';
    }

    // Check if typed value matches any plan price exactly
    final matchIndex = plans.indexWhere((p) => p.price == typed);
    if (matchIndex != -1) {
      isCustomAmount.value = false;
      selectedIndex.value = matchIndex;
      customRpInfo.value = '';
    } else {
      isCustomAmount.value = true;
      selectedIndex.value = -1;
      // Show estimated commission info for custom amount (use avg commission)
      if (plans.isNotEmpty) {
        final avgCommission =
            plans.map((p) => p.commissionPercent).reduce((a, b) => a + b) /
            plans.length;
        final estimated = (typed * avgCommission / 100).round();
        customRpInfo.value =
            'Approx RP you will get: ${typed + estimated} RP (incl. ~${avgCommission.round()}% bonus)';
      } else {
        customRpInfo.value = '';
      }
    }
  }

  // ================= CLEAR AMOUNT =================
  void clearAmount() {
    if (plans.isNotEmpty) {
      selectedIndex.value = 0;
      amountController.text = plans.first.price.toString();
      amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length),
      );
    } else {
      amountController.clear();
    }
    isCustomAmount.value = false;
    customRpInfo.value = '';
    amountError.value = '';
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     refreshAfterPayment();
  //   }
  // }

  // ================= LOAD PLANS + WALLET =================
  Future<void> loadPlans() async {
    try {
      isLoading.value = true;

      final result = await _rpService.getBuyRPPlans();
      plans.assignAll(result.$1);
      wallet = result.$2;

      if (plans.isNotEmpty) {
        selectedIndex.value = 0;
        isCustomAmount.value = false;
        customRpInfo.value = '';
        amountController.text = plans.first.price.toString();
      }
    } catch (e, stk) {
      Get.snackbar("Error", "Failed to load RP plans");
      log("plans $e $stk ");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SELECT PLAN =================
  void selectPlan(int index) {
    if (index < 0 || index >= plans.length) return;

    selectedIndex.value = index;
    isCustomAmount.value = false;
    customRpInfo.value = '';
    amountError.value = '';
    amountController.text = plans[index].price.toString();
    amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: amountController.text.length),
    );
  }

  // ================= COMMISSION TEXT =================
  String commissionText() {
    if (isCustomAmount.value) return customRpInfo.value;
    if (plans.isEmpty || selectedIndex.value < 0) return '';

    final plan = plans[selectedIndex.value];
    final commission = (plan.rpAmount * plan.commissionPercent) / 100;
    final total = plan.rpAmount + commission;

    return "If you buy ${plan.rpAmount} RP, you will get ${total.toInt()} RP";
  }

  // ================= START PAYMENT =================
  Future<void> startPayment() async {
    if (plans.isEmpty) {
      Get.snackbar("Error", "Plans not loaded yet");
      return;
    }

    // Validate custom amount or plan selection
    final typedText = amountController.text.trim();
    final typedAmount = int.tryParse(typedText);
    if (typedAmount == null || typedAmount <= 0) {
      Get.snackbar(
        "Invalid Amount",
        "Please enter a valid amount to proceed",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // If custom amount, validate against minimum plan price
    final minPrice = plans.map((p) => p.price).reduce((a, b) => a < b ? a : b);
    if (isCustomAmount.value && typedAmount < minPrice) {
      Get.snackbar(
        "Amount Too Low",
        "Minimum amount is ₹$minPrice",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isPaying.value = true;
      _isProcessingPayment = false; // Reset processing flag

      final plan = plans[selectedIndex.value];

      /// 🔥 CREATE PAYMENT
      final res = await _rpService.createBuyPayment(planId: plan.id);

      /// ✅ Store order ID for tracking
      lastOrderId = res.orderId.toString();
      debugPrint("💳 Payment initiated with Order ID: $lastOrderId");

      final uri = Uri.tryParse(res.upiIntentUrl);
      if (uri == null) {
        lastOrderId = null;
        throw "Invalid UPI URL received";
      }

      /// 🌐 Navigate to PaymentWebViewPage
      final result = await Get.toNamed(
        Routes.paymentWebView,
        arguments: {'paymentUrl': res.upiIntentUrl, 'orderId': lastOrderId},
      );

      /// ✅ Handle payment result when WebView closes
      if (result == true) {
        debugPrint("🔄 WebView returned success, checking payment status...");
        // refreshAfterPayment handles status check, snackbar, loadPlans & fetchHome
        await refreshAfterPayment();
      } else {
        debugPrint("❌ WebView closed without success signal");
        lastOrderId = null;
      }
    } catch (e) {
      debugPrint("❌ Payment start error: $e");
      lastOrderId = null;
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      // Always reset paying state so button never stays stuck
      isPaying.value = false;
    }
  }

  // ================= SUBMIT MANUAL PAYMENT =================
  Future<void> submitManualPayment(String paymentId) async {
    if (plans.isEmpty) {
      Get.snackbar("Error", "Plans not loaded yet");
      return;
    }

    final typedText = amountController.text.trim();
    final typedAmount = int.tryParse(typedText);
    if (typedAmount == null || typedAmount <= 0) {
      Get.snackbar(
        "Error",
        "Please enter a valid amount",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final String planId;
    if (selectedIndex.value >= 0 && selectedIndex.value < plans.length) {
      planId = plans[selectedIndex.value].id;
    } else {
      planId = plans.first.id; // Fallback for custom amount if needed by API
    }

    try {
      isPaying.value = true;
      await _rpService.submitBuyRequest(
        planId: planId,
        paymentId: paymentId,
        amount: typedAmount,
      );

      Get.back(); // Go back from UPI details screen
      Get.snackbar(
        "Request Submitted",
        "Your buy request has been submitted successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearAmount();
      await _refreshAllUIs();
    } catch (e) {
      debugPrint("❌ Manual payment error: $e");
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isPaying.value = false;
    }
  }

  // ================= HANDLE PAYMENT COMPLETION =================
  /// Called when WebView closes with success signal
  Future<void> _handlePaymentCompletion() async {
    if (lastOrderId == null || _isProcessingPayment) {
      debugPrint(
        "⚠️ Skipping payment processing: orderId=$lastOrderId, isProcessing=$_isProcessingPayment",
      );
      return;
    }

    try {
      _isProcessingPayment = true;
      debugPrint("🔍 Checking payment status for Order ID: $lastOrderId");

      final status = await _rpService.checkPaymentStatus(lastOrderId!);
      debugPrint("📊 Payment status: $status");

      if (status == "success") {
        debugPrint("✅ Payment successful! Refreshing all data...");
        _refreshAllUIs();

        Get.snackbar(
          "Payment Successful 🎉",
          "RP has been added to your wallet",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else if (status == "failed") {
        debugPrint("❌ Payment failed");
        Get.snackbar(
          "Payment Failed ❌",
          "Amount was not deducted",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        debugPrint("⚠️ Payment status unknown: $status");
      }
    } catch (e) {
      debugPrint("❌ Error checking payment status: $e");
      Get.snackbar(
        "Error",
        "Could not verify payment status. Please check your transaction history.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      lastOrderId = null;
      _isProcessingPayment = false;
      _refreshAllUIs();
    }
  }

  Future<void> _refreshAllUIs() async {
    /// 🔄 Refresh Buy RP data (wallet + plans)
    await loadPlans();

    /// 🔄 Refresh Home screen data
    if (Get.isRegistered<HomeController>()) {
      try {
        await Get.find<HomeController>().fetchHome();
        debugPrint("✅ Home data refreshed");
      } catch (e) {
        debugPrint("⚠️ HomeController error: $e");
      }
    } else {
      debugPrint("⚠️ HomeController not registered yet");
    }
  }

  // ================= AFTER APP RESUME =================
  /// Called when app resumes from background (e.g., after external UPI app)
  Future<void> refreshAfterPayment() async {
    if (lastOrderId == null) {
      debugPrint("⚠️ No pending order to check");
      return;
    }

    if (_isProcessingPayment) {
      debugPrint(
        "⚠️ Payment already being processed, skipping duplicate check",
      );
      return;
    }

    debugPrint("🔄 App resumed, checking payment status...");
    await _handlePaymentCompletion();
  }
}
