import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/home_controller.dart';
import 'package:rp_app/views/components/Home/bank_details_card.dart';
import 'package:rp_app/views/components/Home/home_slider.dart';
import 'package:rp_app/views/components/Home/learning_section.dart';
import 'package:rp_app/views/components/Home/quick_actions.dart';
import 'package:rp_app/views/components/Home/stats_card.dart';
import 'package:rp_app/views/components/Home/wallet_balance_card.dart';

import 'components/shimmer/home_shimmer.dart';

class HomeTabScreen extends GetView<HomeController> {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF6A11CB).withOpacity(0.1),
            child: const Icon(Icons.person_rounded, color: Color(0xFF6A11CB)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back,",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const Text(
              "👋",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6A11CB).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF6A11CB),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      /// BODY
      body: RefreshIndicator(
        onRefresh: controller.fetchHome,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const HomeShimmer();
          }

          if (controller.homeData.value == null) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: const Center(child: Text("Failed to load data")),
              ),
            );
          }

          final homeData = controller.homeData.value!;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// WALLET
                WalletBalanceCard(),

                const SizedBox(height: 25),

                /// QUICK ACTIONS
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const QuickActions(),

                const SizedBox(height: 30),

                /// BANK DETAILS
                AddBankDetailsCard(
                  hasBank: homeData.bank?.hasBank ?? false,
                  accounts: homeData.bank?.accounts ?? [],
                  message: homeData.bank?.message,
                ),

                const SizedBox(height: 20),

                /// SLIDER
                HomeSlider(banners: homeData.banners),

                const SizedBox(height: 20),

                /// STATISTICS
                StatisticsCard(
                  stats: homeData.todayStats,
                  todayCommission: homeData.todayCommission,
                ),

                const SizedBox(height: 30),

                /// LEARNING
                const TutorialSection(),

                const SizedBox(height: 50),
              ],
            ),
          );
        }),
      ),
    );
  }
}
