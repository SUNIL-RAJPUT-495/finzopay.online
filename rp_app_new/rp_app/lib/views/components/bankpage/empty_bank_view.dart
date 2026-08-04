import 'package:flutter/material.dart';

class EmptyBankView extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyBankView({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No bank added",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onAdd, child: const Text("Add Bank")),
        ],
      ),
    );
  }
}
