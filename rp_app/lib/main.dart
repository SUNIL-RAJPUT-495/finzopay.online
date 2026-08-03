import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/profile_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/buy_rp_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/sell_rp_controller.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomeController(), permanent: true);
  Get.put(SellRPController(), permanent: true);
  Get.put(BuyRPController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinzoPay',
      home: SplashScreen(),
    );
  }
}
