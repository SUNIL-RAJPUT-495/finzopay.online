import 'package:flutter/material.dart';

import '../../../models/home_model.dart';
import '../../../views/manage_bank_page.dart';

class AddBankDetailsCard extends StatelessWidget {
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
        child: hasBank && accounts.isNotEmpty
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
          message ?? "Enter your bank information to receive payments",
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),

        _bankTextField(
          hint: "Account Holder Name",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),

        _bankTextField(
          hint: "Bank Name",
          icon: Icons.account_balance_outlined,
        ),
        const SizedBox(height: 12),

        _bankTextField(
          hint: "Account Number",
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),

        _bankTextField(
          hint: "IFSC Code",
          icon: Icons.confirmation_number_outlined,
        ),
        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManageBankPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
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

        ...accounts.map(_singleBankView).toList(),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManageBankPage()),
              );
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
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
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
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.white70),
          ),
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
}) {
  return TextField(
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
