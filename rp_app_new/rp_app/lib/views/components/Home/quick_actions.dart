import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rp_app/routes/app_routes.dart';
import 'package:rp_app/views/sell_rp.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _quickActionButton(
            icon: Icons.history_rounded,
            label: "Buy RP History",
            color: const Color(0xFF10B981),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withOpacity(0.1),
                const Color(0xFF10B981).withOpacity(0.3),
              ],
            ),
            onTap: () {
              Get.toNamed(Routes.buyRpHistory);
            },
          ),

          _quickActionButton(
            icon: Icons.history_rounded,
            label: "Sell RP History",
            color: const Color(0xFF8B5CF6),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B5CF6).withOpacity(0.1),
                const Color(0xFF8B5CF6).withOpacity(0.3),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SellRPScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// SAME BUTTON CODE – ZERO DESIGN CHANGE
  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
