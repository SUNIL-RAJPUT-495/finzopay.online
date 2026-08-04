import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:rp_app/controllers/buy_rp_controller.dart';
import 'package:rp_app/routes/app_routes.dart';
import 'package:rp_app/views/buy_upi_details.dart';
import 'package:shimmer/shimmer.dart';

class BuyRPTabScreen extends GetView<BuyRPController> {
  const BuyRPTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          "Buy RP",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.buyRpHistory);
            },
            child: const Text(
              "Buy RP history",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),

      /// BODY
      body: RefreshIndicator(
        onRefresh: controller.loadPlans,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return _buildBalanceShimmer();
                }
                return _balanceCard();
              }),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value) {
                  return _buildDepositShimmer();
                }
                return _depositAmountCard();
              }),

              SizedBox(height: Get.height * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  Widget _buildDepositShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
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
            final visibleCount = controller.plans.length > 12
                ? 12
                : controller.plans.length;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(visibleCount, (i) {
                final selected = controller.selectedIndex.value == i;
                final plan = controller.plans[i];

                return GestureDetector(
                  onTap: () => controller.selectPlan(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
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
            );
          }),

          const SizedBox(height: 16),
          _amountField(),

          const SizedBox(height: 8),
          Obx(() {
            final text = controller.commissionText();
            if (text.isEmpty) return const SizedBox.shrink();
            final isCustom = controller.isCustomAmount.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCustom
                    ? const Color(0xFFFFF8E1)
                    : const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCustom
                      ? const Color(0xFFFFCA28)
                      : const Color(0xFF9575CD),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isCustom ? Icons.info_outline : Icons.redeem,
                    size: 16,
                    color: isCustom
                        ? const Color(0xFFF57F17)
                        : const Color(0xFF6A11CB),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 13,
                        color: isCustom
                            ? const Color(0xFFF57F17)
                            : const Color(0xFF6A11CB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
          Obx(() => _depositButton()),
        ],
      ),
    );
  }

  Widget _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with "Or enter custom amount" hint
        Obx(
          () => Row(
            children: [
              const Text(
                "Amount",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              if (controller.isCustomAmount.value) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A11CB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Custom",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6A11CB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Amount input container
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF6A11CB).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Text(
                "₹",
                style: TextStyle(
                  color: Color(0xFF6A11CB),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter amount",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              // Clear / reset button
              Obx(() {
                final hasText = controller.hasAmount.value;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: hasText
                      ? GestureDetector(
                          key: const ValueKey('clear'),
                          onTap: controller.clearAmount,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                );
              }),
            ],
          ),
        ),
        Obx(() {
          if (controller.amountError.value.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: Colors.red.shade600),
                const SizedBox(width: 4),
                Text(
                  controller.amountError.value,
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _depositButton() {
    final isDisabled = controller.isPaying.value;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDisabled
              ? [Colors.grey.shade400, Colors.grey.shade500]
              : [const Color(0xFF6A11CB), const Color(0xFF9F7AEA)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDisabled
                ? Colors.grey.withOpacity(0.2)
                : const Color(0xFF6A11CB).withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        // onPressed: isDisabled ? null : controller.startPayment,
        onPressed: () {
          if (controller.amountError.value.isNotEmpty) {
            Get.snackbar(
              "Invalid Amount",
              controller.amountError.value,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            return;
          }
          final text = controller.amountController.text.trim();
          if (text.isEmpty) {
            Get.snackbar(
              "Invalid Amount",
              "Please enter an amount",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            return;
          }
          Get.to(() => BuyUpiDetails());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isDisabled
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Processing...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                "Buy RP",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  static BoxDecoration _cardDecoration() {
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
