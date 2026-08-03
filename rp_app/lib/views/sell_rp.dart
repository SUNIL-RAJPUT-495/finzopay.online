import 'package:flutter/material.dart';
import 'package:rp_app/models/sell_rp_model.dart';
import 'package:rp_app/services/rp_service.dart';
import 'package:shimmer/shimmer.dart';

class SellRPScreen extends StatefulWidget {
  const SellRPScreen({super.key});

  @override
  State<SellRPScreen> createState() => _SellRPScreenState();
}

class _SellRPScreenState extends State<SellRPScreen> {
  final RPService _rpService = RPService();

  bool isLoading = true;
  List<SellRPModel> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final data = await _rpService.getSellRPHistory();

      if (!mounted) return;

      setState(() {
        history = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Sell RP Error: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

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
      body: isLoading
          ? ListView(
              padding: const EdgeInsets.all(12),
              children: List.generate(6, (_) => sellRpShimmerCard()),
            )
          : history.isEmpty
          ? const Center(child: Text("No sell history found"))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: history.map(_rpCard).toList(),
            ),
    );
  }

  /// RP CARD
  Widget _rpCard(SellRPModel data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ID + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${data.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    data.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: data.status == "pending"
                      ? Colors.orange
                      : Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// RP + AMOUNT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RP Sold: ${data.rpSold} RP",
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "Amount: ₹${data.amount}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// BANK INFO
            Text(
              "Bank: ${data.bankName} • ****${data.accountLast4}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

Widget sellRpShimmerCard() {
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
            Container(height: 16, width: 160, color: Colors.white),
            const SizedBox(height: 12),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 8),
            Container(height: 12, width: 180, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}
