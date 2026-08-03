import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/social_controller.dart';

class SocialScreen extends StatelessWidget {
  final SocialController controller = Get.put(SocialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Online Service")),

      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse(controller.links!.supportTelegram));
                },
                child: Text("Telegram Support"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse(controller.links!.supportWhatsapp));
                },
                child: Text("WhatsApp Support"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
