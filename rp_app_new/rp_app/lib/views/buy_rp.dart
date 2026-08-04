import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/buy_rp_history_controller.dart';
import 'package:rp_app/models/buy_rp_model.dart';
import 'package:shimmer/shimmer.dart';

class BuyRPScreen extends GetView<BuyRPHistoryController> {
  const BuyRPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// TOP BAR
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),

      /// BODY
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: List.generate(6, (_) => rpShimmerCard()),
          );
        }

        if (controller.history.isEmpty) {
          return const Center(child: Text("No history found"));
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: controller.history.map(_rpCard).toList(),
        );
      }),
    );
  }

  /// RP CARD
  Widget _rpCard(BuyRPModel data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ID + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${data.paymentId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    data.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Payment & Award
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Amount: ${data.paymentAmount} RP",
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "Award: ${data.baseRp}+${data.commissionRp} RP",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SHIMMER
Widget rpShimmerCard() {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16, width: 150, color: Colors.white),
            const SizedBox(height: 12),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 8),
            Container(height: 14, width: 180, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}
