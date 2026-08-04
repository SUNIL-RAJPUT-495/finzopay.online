import 'dart:developer';

import 'package:rp_app/models/buy_rp_plan_model.dart';
import 'package:rp_app/models/sell_page_model.dart';
import 'package:rp_app/models/sell_rp_model.dart';
import '../services/api_service.dart';
import '../models/buy_rp_model.dart';

/// =======================
/// BUY RP PAYMENT MODELS
/// =======================

class CreatePaymentResponse {
  final int orderId;
  final String upiIntentUrl;

  CreatePaymentResponse({required this.orderId, required this.upiIntentUrl});

  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    if (json['upiIntentUrl'] == null ||
        json['upiIntentUrl'].toString().isEmpty) {
      throw Exception("Payment URL missing from API");
    }

    return CreatePaymentResponse(
      orderId: json['order_id'],
      upiIntentUrl: json['upiIntentUrl'],
    );
  }
}

class VerifyPaymentResponse {
  final String orderId;
  final String paymentStatus;

  VerifyPaymentResponse({required this.orderId, required this.paymentStatus});

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      orderId: json['order_id'],
      paymentStatus: json['payment_status'],
    );
  }
}

/// =======================
/// RP SERVICE
/// =======================

class RPService {
  final ApiService _apiService = ApiService();

  // ================= BUY HISTORY =================
  Future<List<BuyRPModel>> getBuyRPHistory() async {
    final response = await _apiService.get("/rp/buy/history");

    final List list = response['data'];
    return list.map((e) => BuyRPModel.fromJson(e)).toList();
  }

  // ================= SELL HISTORY =================
  Future<List<SellRPModel>> getSellRPHistory() async {
    final response = await _apiService.get("/rp/sell/history");
    log("Sell RP History: $response");
    final List list = response['data'];
    log("Sell RP History List: $list");
    return list.map((e) => SellRPModel.fromJson(e)).toList();
  }

  // ================= BUY PLANS =================
  Future<(List<BuyRPPlanModel>, WalletModel)> getBuyRPPlans() async {
    final response = await _apiService.get("/rp/plans");

    final plans = (response['data']['plans'] as List)
        .map((e) => BuyRPPlanModel.fromJson(e))
        .toList();

    final wallet = WalletModel.fromJson(response['data']['wallet']);

    return (plans, wallet);
  }

  // ================= All RP PLANS =================
  Future<(List<BuyRPPlanModel>, WalletModel)> getAllRPPlans() async {
    final response = await _apiService.get("/rp/plans/all");

    final plans = (response['data']['plans'] as List)
        .map((e) => BuyRPPlanModel.fromJson(e))
        .toList();

    final wallet = WalletModel.fromJson(response['data']['wallet']);

    return (plans, wallet);
  }

  // ================= SELL PAGE =================
  Future<SellRPResponse> getSellPageData() async {
    final response = await _apiService.get(
      "/rp/sell-page",
      useCache: false,
    );
    log("getSellPageData $response");
    return SellRPResponse.fromJson(response['data']);
  }

  // ================= SELL RP =================
  Future<String> sellRp({
    required int rpAmount,
    required String bankAccountId,
  }) async {
    final response = await _apiService.post("/rp/sell", {
      "rp_amount": rpAmount.toString(),
      "bankAccountId": bankAccountId,
    });
    log("Sell RP Response: $response");
    if (response['success'] == true) {
      return response['sellRequestId'];
    } else {
      throw Exception(response['message'] ?? "Sell RP failed");
    }
  }

  // =====================================================
  // 🔥 NEW : BUY RP – CREATE PAYMENT (UPI)
  // =====================================================
  Future<CreatePaymentResponse> createBuyPayment({
    required String planId,
  }) async {
    final response = await _apiService.post("/create/payment", {
      "planId": planId,
    });

    if (response['success'] != true) {
      throw Exception(response['message'] ?? "Payment creation failed");
    }

    return CreatePaymentResponse.fromJson(response);
  }

  // =====================================================
  // 🔥 VERIFY PAYMENT
  // =====================================================
  Future<String> checkPaymentStatus(String orderId) async {
    final res = await _apiService.get("/payment/status/$orderId");
    return res['status']; // success | failed | pending
  }

  // =====================================================
  // 🔥 NEW : BUY RP – VERIFY PAYMENT
  // =====================================================
  Future<VerifyPaymentResponse> verifyBuyPayment({
    required String orderId,
    required String gatewayTxnId,
    required String status,
  }) async {
    final response = await _apiService.post("/verify/payment", {
      "order_id": orderId,
      "gateway_txn_id": gatewayTxnId,
      "status": status,
    });

    return VerifyPaymentResponse.fromJson(response['data']);
  }

  // =====================================================
  // 🔥 NEW : GET UPI DETAILS
  // =====================================================
  Future<Map<String, dynamic>> getUpiDetails() async {
    final response = await _apiService.get("/upi/details");
    return response;
  }

  // =====================================================
  // 🔥 NEW : SUBMIT BUY REQUEST
  // =================================================  ====
  Future<void> submitBuyRequest({
    required String planId,
    required String paymentId,
    required int amount,
  }) async {
    final response = await _apiService.post("/rp/buy", {
      "planId": planId,
      "payment_id": paymentId,
      "amount": amount,
    });

    if (response['success'] == false && response['message'] != null) {
      throw Exception(response['message']);
    }
  }
}
