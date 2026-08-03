import 'package:flutter/material.dart';
import '../../../models/bank_model.dart';
import '../../../utils/indian_banks.dart';

class BankFormSheet extends StatefulWidget {
  final BankAccount? bank;
  final Function(Map<String, dynamic>) onSubmit;

  const BankFormSheet({super.key, this.bank, required this.onSubmit});

  @override
  State<BankFormSheet> createState() => _BankFormSheetState();
}

class _BankFormSheetState extends State<BankFormSheet> {
  final holder = TextEditingController();
  final bankName = TextEditingController();
  final account = TextEditingController();
  final ifsc = TextEditingController();

  String? selectedBank;

  @override
  void initState() {
    super.initState();

    if (widget.bank != null) {
      holder.text = widget.bank!.holderName;
      bankName.text = widget.bank!.bankName;
      account.text = widget.bank!.accountNumber;
      ifsc.text = widget.bank!.ifsc;
      selectedBank = widget.bank!.bankName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.bank == null ? "Add Bank" : "Edit Bank",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),

            _field(holder, "Account Holder"),

            /// ✅ BANK DROPDOWN
            _bankDropdown(),

            _field(account, "Account Number", isNumber: true),
            _field(ifsc, "IFSC Code"),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 BANK DROPDOWN
  Widget _bankDropdown() {
    final sortedBanks = [...indianBanks]..sort();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedBank,
        isExpanded: true,
        items: sortedBanks
            .map(
              (bank) => DropdownMenuItem(
                value: bank,
                child: Text(bank, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedBank = value;
            bankName.text = value ?? "";
          });
        },
        decoration: InputDecoration(
          hintText: "Select Bank",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// 🔹 COMMON TEXT FIELD
  Widget _field(TextEditingController c, String hint, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// 🔹 SUBMIT
  void _submit() {
    if (holder.text.isEmpty ||
        bankName.text.isEmpty ||
        account.text.isEmpty ||
        ifsc.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    widget.onSubmit({
      "account_holder": holder.text,
      "bank_name": bankName.text,
      "account_number": account.text,
      "ifsc": ifsc.text,
    });
  }
}
