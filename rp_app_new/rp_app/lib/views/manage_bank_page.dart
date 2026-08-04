import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/bank_controller.dart';

import 'package:rp_app/views/components/bankpage/bank_form_sheet.dart';
import 'package:rp_app/views/components/bankpage/bank_list_card.dart';
import 'package:rp_app/views/components/bankpage/empty_bank_view.dart';

import '../../models/bank_model.dart';

class ManageBankPage extends GetView<ManageBankController> {
  const ManageBankPage({super.key});

  void _openForm(BuildContext context, {BankAccount? bank}) {
    log("📝 Opening bank form - Mode: ${bank == null ? 'ADD' : 'EDIT'}");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BankFormSheet(
        bank: bank,
        onSubmit: (data) async {
          try {
            log("📤 Form submitted with data: $data");
            Get.back(); // close bottom sheet
            if (bank == null) {
              /// ➕ ADD BANK
              log("➕ Adding new bank...");
              await controller.addBank(data);
            } else {
              /// ✏️ UPDATE BANK
              log("✏️ Updating bank ID: ${bank.id}");
              await controller.updateBank(bank.id, data);
            }

            log("✅ Form submission successful, closing sheet");
          } catch (e) {
            log("❌ Form submission failed: $e");
            // Error is already handled in controller with snackbar
            // Just close the sheet
            Get.back();
          }
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
          return EmptyBankView(onAdd: () => _openForm(context));
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
