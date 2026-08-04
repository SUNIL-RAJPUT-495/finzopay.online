import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rp_plan_controller.dart';

class RPPlanScreen extends StatelessWidget {
  RPPlanScreen({super.key});

  final controller = Get.put(RPPlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Newbie Rewards")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.plans.length,
          itemBuilder: (_, i) {
            final plan = controller.plans[i];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ ${plan.price}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text("Base RP: ${plan.rpAmount}"),
                    Text("Commission: ${plan.commissionPercent}%"),
                    Text("Extra RP: ${plan.commissionRp}"),

                    const Divider(),

                    Text(
                      "Final RP: ${plan.finalRp}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.buyNow(plan),
                        child: const Text("Buy Now"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
