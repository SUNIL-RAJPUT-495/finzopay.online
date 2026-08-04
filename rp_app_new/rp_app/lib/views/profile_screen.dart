import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/routes/app_routes.dart';
import 'package:rp_app/views/Official_screen.dart';
import 'package:rp_app/views/common_problem_screen.dart';
import 'package:rp_app/views/rp_plan_screen.dart';
import 'package:rp_app/views/social_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// PROFILE HEADER
              Obx(() {
                if (controller.isLoading.value) {
                  return _buildHeaderShimmer();
                }
                if (controller.profile.value == null) return const SizedBox();
                final profile = controller.profile.value!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MOBILE: ${profile.phone}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(profile.name),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              /// BALANCE CARD
              Obx(() {
                if (controller.isLoading.value) {
                  return _buildBalanceShimmer();
                }
                if (controller.profile.value == null) return const SizedBox();
                final profile = controller.profile.value!;
                return _card(
                  child: ListTile(
                    title: const Text("Current Balance"),
                    subtitle: Text(
                      profile.balance.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              }),

              /// MENU LIST (Static content always visible)
              _menuItem(
                Icons.card_giftcard,
                "Newbie Rewards",
                onTap: () => Get.to(() => RPPlanScreen()),
              ),
              _menuItem(
                Icons.account_balance,
                "Bank Card",
                onTap: () => Get.toNamed(Routes.addBank),
              ),
              _menuItem(
                Icons.help_outline,
                "Common problem",
                onTap: () => Get.to(() => CommonProblemScreen()),
              ),
              _menuItem(
                Icons.headset_mic,
                "Online service",
                onTap: () => Get.to(() => SocialScreen()),
              ),
              _menuItem(
                Icons.lock_reset,
                "Reset password",
                onTap: () => Get.toNamed(Routes.changePassword),
              ),
              _menuItem(
                Icons.chat,
                "Official Channel",
                onTap: () => Get.to(() => OfficialChannelScreen()),
              ),

              const SizedBox(height: 20),

              /// LOGOUT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: controller.logout,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            const CircleAvatar(radius: 30, backgroundColor: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: 120, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(
                    height: 24,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 90, // Approx height of balance card
          ),
        ),
      ),
    );
  }

  /// COMMON CARD
  Widget _card({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }

  /// MENU ITEM
  Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        margin: const EdgeInsets.only(top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
