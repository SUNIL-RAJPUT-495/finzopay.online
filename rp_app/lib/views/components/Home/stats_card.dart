import 'package:flutter/material.dart';
import 'package:rp_app/models/home_model.dart';

class StatisticsCard extends StatelessWidget {
  final TodayStats stats;
  final double todayCommission;

  const StatisticsCard({
    super.key,
    required this.stats,
    required this.todayCommission,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
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
                  "Today's Stats",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A11CB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Live",
                    style: TextStyle(
                      color: Color(0xFF6A11CB),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// GRID
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _StatItem(
                  title: "Buy Quantity",
                  value: stats.buyQuantity.toString(),
                  icon: Icons.shopping_cart_rounded,
                  color: const Color(0xFF3B82F6),
                ),
                _StatItem(
                  title: "Buy Amount",
                  value: "₹ ${stats.buyAmount.toStringAsFixed(2)}",
                  icon: Icons.currency_rupee_rounded,
                  color: const Color(0xFF10B981),
                ),
                _StatItem(
                  title: "Sell Today",
                  value: "₹ ${stats.sellToday.toStringAsFixed(2)}",
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFFF59E0B),
                ),
                _StatItem(
                  title: "Today's Commission",
                  value: "₹ ${todayCommission.toStringAsFixed(2)}",
                  icon: Icons.bar_chart_rounded,
                  color: const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SAME STAT ITEM – NO DESIGN CHANGE
class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
