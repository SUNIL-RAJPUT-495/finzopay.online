import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:rp_app/controllers/buy_rp_controller.dart';
import 'buy_rp.dart';

class BuyRPTabScreen extends StatefulWidget {
  const BuyRPTabScreen({super.key});

  @override
  State<BuyRPTabScreen> createState() => _BuyRPTabScreenState();
}

class _BuyRPTabScreenState extends State<BuyRPTabScreen>
    with WidgetsBindingObserver {
  // final BuyRPController controller = Get.put(BuyRPController());
  final BuyRPController controller = Get.find<BuyRPController>();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // if (controller.plans.isEmpty) {
    //   controller.loadPlans();
    // }
    controller.loadPlans();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🔁 Detect app resume (UPI return)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.refreshAfterPayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Buy RP",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => BuyRPScreen());
            },
            child: const Text(
              "Buy RP history",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),

      /// BODY
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _balanceCard(),
              const SizedBox(height: 16),
              _depositAmountCard(),
            ],
          ),
        );
      }),
    );
  }

  // ================= BALANCE CARD =================
  Widget _balanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF9F7AEA)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white),
              SizedBox(width: 8),
              Text("Balance", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "${controller.wallet?.availableRp ?? 0} RP",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  // ================= DEPOSIT CARD =================
  Widget _depositAmountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Buy RP", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          /// PLANS
          Obx(() {
            final plansToShowCount = _isExpanded
                ? controller.plans.length
                : controller.plans.where((p) => p.price <= 1200).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(plansToShowCount, (i) {
                    final selected = controller.selectedIndex.value == i;
                    final plan = controller.plans[i];

                    return GestureDetector(
                      onTap: () => controller.selectPlan(i),
                      child: Container(
                        width: 90,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: selected
                              ? const LinearGradient(
                                  colors: [Color(0xFF6A11CB), Color(0xFF9F7AEA)],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : Colors.grey.shade300,
                          ),
                          color: selected ? null : Colors.white,
                        ),
                        child: Text(
                          "₹ ${plan.price}",
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                if (controller.plans.any((p) => p.price > 1200)) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      icon: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF6A11CB),
                        size: 18,
                      ),
                      label: Text(
                        _isExpanded ? "Show Less" : "View More",
                        style: const TextStyle(
                          color: Color(0xFF6A11CB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }),

          const SizedBox(height: 16),
          _amountField(),

          const SizedBox(height: 8),
          Obx(() {
            return Text(
              controller.commissionText(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            );
          }),

          const SizedBox(height: 16),
          Obx(() => _qrAndUpiSection()),

          const SizedBox(height: 20),
          Obx(() => _depositButton()),
        ],
      ),
    );
  }

  Widget _amountField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text(
            "₹",
            style: TextStyle(color: Color(0xFF6A11CB), fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.amountController,
              enabled: false,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrAndUpiSection() {
    final upi = controller.upiId.value;
    final qr = controller.qrImage.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Scan QR & Pay Manually",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (qr.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Image.network(
                qr,
                height: 180,
                width: 180,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 180,
                    width: 180,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 180,
                    width: 180,
                    child: Center(
                      child: Text(
                        "Unable to load QR Code Image",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "No QR Code image available",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (upi.isNotEmpty) ...[
            const Text(
              "Or transfer directly to UPI ID",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      upi,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: upi));
                      Get.snackbar(
                        "Copied",
                        "UPI ID copied to clipboard",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF6A11CB),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A11CB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.copy,
                            size: 12,
                            color: Color(0xFF6A11CB),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Copy",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Text(
              "No UPI ID configured",
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Transaction Ref / UTR ID",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller.utrController,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter UTR / Transaction ID",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _depositButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.isPaying.value ? null : controller.submitUtrPayment,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF9F7AEA)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: controller.isPaying.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Submit Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
