import 'package:flutter/material.dart';
import 'package:rp_app/models/home_model.dart';

class WalletBalanceCard extends StatelessWidget {
  final Wallet wallet;
  final double todayCommission;

  const WalletBalanceCard({
    super.key,
    required this.wallet,
    required this.todayCommission,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A11CB).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Balance",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.currency_rupee, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        "INR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// TOTAL BALANCE
            Text(
              "₹ ${wallet.totalBalance.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 20),

            /// FOOTER VALUES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _balanceItem(
                  title: "Available",
                  value: "₹ ${wallet.availableBalance.toStringAsFixed(2)}",
                  color: Colors.green.shade300,
                ),
                _balanceItem(
                  title: "Today Commission",
                  value: "₹ ${todayCommission.toStringAsFixed(2)}",
                  color: Colors.orange.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
