import 'package:flutter/material.dart';
import '../../../models/bank_model.dart';

class BankListCard extends StatelessWidget {
  final BankAccount bank;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BankListCard({
    super.key,
    required this.bank,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bank.bankName,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text("•••• ${bank.accountNumber.substring(bank.accountNumber.length - 4)}"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onEdit, child: const Text("Edit")),
                TextButton(
                  onPressed: onDelete,
                  child: const Text("Delete",
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
