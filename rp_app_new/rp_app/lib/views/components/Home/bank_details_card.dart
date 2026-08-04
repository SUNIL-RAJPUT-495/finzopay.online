import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/home_model.dart';
import '../../../routes/app_routes.dart';
import '../../../controllers/bank_controller.dart';

class AddBankDetailsCard extends StatefulWidget {
  final bool hasBank;
  final List<BankAccount> accounts;
  final String? message;

  const AddBankDetailsCard({
    super.key,
    this.hasBank = false,
    this.accounts = const [],
    this.message,
  });

  @override
  State<AddBankDetailsCard> createState() => _AddBankDetailsCardState();
}

class _AddBankDetailsCardState extends State<AddBankDetailsCard> {
  final _holderController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveBank() async {
    if (_holderController.text.trim().isEmpty ||
        _bankController.text.trim().isEmpty ||
        _accountController.text.trim().isEmpty ||
        _ifscController.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please fill all bank details.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final controller = Get.isRegistered<ManageBankController>()
          ? Get.find<ManageBankController>()
          : Get.put(ManageBankController());

      await controller.addBank({
        "account_holder": _holderController.text.trim(),
        "bank_name": _bankController.text.trim(),
        "account_number": _accountController.text.trim(),
        "ifsc": _ifscController.text.trim(),
      });

      _holderController.clear();
      _bankController.clear();
      _accountController.clear();
      _ifscController.clear();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: widget.hasBank && widget.accounts.isNotEmpty
            ? _bankDetailsView(context)
            : _addBankForm(context),
      ),
    );
  }

  // ================= WHEN NO BANK =================
  Widget _addBankForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add Bank Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.message ?? "Enter your bank information to receive payments",
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),

        _bankTextField(
          hint: "Account Holder Name",
          icon: Icons.person_outline,
          controller: _holderController,
        ),
        const SizedBox(height: 12),

        _bankTextField(
          hint: "Bank Name",
          icon: Icons.account_balance_outlined,
          controller: _bankController,
        ),
        const SizedBox(height: 12),

        _bankTextField(
          hint: "Account Number",
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          controller: _accountController,
        ),
        const SizedBox(height: 12),

        _bankTextField(
          hint: "IFSC Code",
          icon: Icons.confirmation_number_outlined,
          controller: _ifscController,
        ),
        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveBank,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF8B5CF6),
                    ),
                  )
                : const Text(
                    "Save Bank Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
          ),
        ),
      ],
    );
  }

  // ================= WHEN BANK(S) EXIST =================
  Widget _bankDetailsView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bank Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...widget.accounts.map(_singleBankView).toList(),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.toNamed(Routes.addBank);
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add New Bank",
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _singleBankView(BankAccount account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Holder", account.holder),
          _infoRow("Bank", account.bankName),
          _infoRow(
            "Account",
            "XXXX${account.accountNumber.substring(account.accountNumber.length - 4)}",
          ),

          // if (account.isDefault)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 6),
          //     child: Align(
          //       alignment: Alignment.centerRight,
          //       child: Container(
          //         padding:
          //         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: const Text(
          //           "Default",
          //           style: TextStyle(
          //             fontSize: 11,
          //             fontWeight: FontWeight.bold,
          //             color: Color(0xFF8B5CF6),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SAME TEXT FIELD – NO DESIGN CHANGE
Widget _bankTextField({
  required String hint,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  TextEditingController? controller,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
