import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/bank_controller.dart';

import 'package:rp_app/views/components/bankpage/bank_form_sheet.dart';
import 'package:rp_app/views/components/bankpage/bank_list_card.dart';
import 'package:rp_app/views/components/bankpage/empty_bank_view.dart';

import '../../models/bank_model.dart';

class ManageBankPage extends StatelessWidget {
  ManageBankPage({super.key});

  final ManageBankController controller =
  Get.put(ManageBankController());

  void _openForm(BuildContext context, {BankAccount? bank}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BankFormSheet(
        bank: bank,
        onSubmit: (data) async {
          if (bank == null) {
            /// ➕ ADD BANK
            await controller.addBank(data);
          } else {
            /// ✏️ UPDATE BANK
            await controller.updateBank(bank.id, data);
          }

          Get.back(); // close bottom sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        title: const Text("Manage Bank"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.banks.isEmpty) {
          return EmptyBankView(
            onAdd: () => _openForm(context),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.banks.length,
          itemBuilder: (_, i) {
            final bank = controller.banks[i];
            return BankListCard(
              bank: bank,
              onEdit: () => _openForm(context, bank: bank),
              onDelete: () => controller.deleteBank(bank.id),
            );
          },
        );
      }),
    );
  }
}
