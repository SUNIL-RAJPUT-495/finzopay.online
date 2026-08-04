import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/support_controller.dart';

class CommonProblemScreen extends StatelessWidget {

  CommonProblemScreen({super.key});

  final SupportController controller = Get.put(SupportController());

  final name = TextEditingController();
  final phone = TextEditingController();
  final message = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // attach clear callback
    controller.clearForm = () {
      name.clear();
      phone.clear();
      message.clear();
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Common Problem")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 10),

            TextField(
              controller: message,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Describe your problem",
              ),
            ),

            const SizedBox(height: 20),

            Obx(() => SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: controller.loading.value
                    ? null
                    : () {
                  controller.submit(
                    name: name.text,
                    phone: phone.text,
                    message: message.text,
                  );
                },

                child: controller.loading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
