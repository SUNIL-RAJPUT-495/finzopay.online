import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/sell_rp_controller.dart';
import '../models/sell_page_model.dart';

class SellRPTabScreen extends StatefulWidget {
  const SellRPTabScreen({super.key});

  @override
  State<SellRPTabScreen> createState() => _SellRPTabScreenState();

  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _SellRPTabScreenState extends State<SellRPTabScreen> {
  final SellRPController controller = Get.find<SellRPController>();

  @override
  void initState() {
    super.initState();
    // if (controller.sellData.value == null) {
    //   controller.loadSellData();
    // }
    controller.loadSellData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Sell RP",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF9F7AEA)],
            ),
          ),
        ),
      ),

      /// BODY
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.sellData.value == null) {
          return const Center(child: Text("Failed to load data"));
        }

        final SellRPResponse data = controller.sellData.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _balanceCard(data),
              const SizedBox(height: 16),
              _bankSection(data),
              const SizedBox(height: 16),
              _amountInput(),
              const SizedBox(height: 16),
              _withdrawRules(),
            ],
          ),
        );
      }),
    );
  }

  // ================= BALANCE CARD =================
  Widget _balanceCard(SellRPResponse data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFB06AB3), Color(0xFF4568DC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Available balance",
                style: TextStyle(color: Colors.white70),
              ),
              Spacer(),
              Icon(Icons.refresh, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BANK SECTION =================
  Widget _bankSection(SellRPResponse data) {
    if (!data.bank.hasBank) {
      return _noBankCard();
    }

    return Column(
      children: [
        _chooseBankCard(),
        Obx(() {
          if (controller.selectedBank.value == null) {
            return const SizedBox();
          }
          return Column(
            children: [
              const SizedBox(height: 12),
              _bankDetailsCard(),
            ],
          );
        }),
      ],
    );
  }

  Widget _noBankCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SellRPTabScreen.cardDecoration(),
      child: Column(
        children: [
          const Text(
            "No bank account added",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please add a bank account to withdraw RP",
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Add Bank"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chooseBankCard() {
    return GestureDetector(
      onTap: _openBankSelector,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: SellRPTabScreen.cardDecoration(),
        child: Row(
          children: [
            const Icon(Icons.account_balance, color: Color(0xFF6A11CB)),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                return Text(
                  controller.selectedBank.value?.bankName ?? "Choose Bank",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                );
              }),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _openBankSelector() {
    final banks = controller.sellData.value!.bank.list;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: banks.map((bank) {
            return ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(bank.bankName),
              subtitle: Text(
                "•••• ${bank.accountNumber.substring(bank.accountNumber.length - 4)}",
              ),
              onTap: () {
                controller.selectBank(bank);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _bankDetailsCard() {
    final bank = controller.selectedBank.value!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SellRPTabScreen.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow("Bank", bank.bankName),
          _detailRow(
            "Account",
            "•••• ${bank.accountNumber.substring(bank.accountNumber.length - 4)}",
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ================= AMOUNT INPUT =================
  Widget _amountInput() {
    return Column(
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: "Please enter the Amount",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : controller.submitSellRp,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF9F7AEA)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Center(
                  child: Text(
                    controller.isSubmitting.value
                        ? "Processing..."
                        : "Withdraw",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _withdrawRules() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SellRPTabScreen.cardDecoration(),
      child: const Text(
        "Sell RP time 10:00 AM – 10:00 PM",
        style: TextStyle(fontSize: 13, color: Colors.black54),
      ),
    );
  }
}
