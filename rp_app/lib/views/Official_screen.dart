import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/social_controller.dart';

class OfficialChannelScreen extends StatelessWidget {
  final SocialController controller = Get.put(SocialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Official Channel")),

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
                  launchUrl(Uri.parse(controller.links!.officialTelegram));
                },
                child: Text("Telegram Support"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse(controller.links!.officialWhatsapp));
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
