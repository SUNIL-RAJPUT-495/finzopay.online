import 'package:get/get.dart';
import 'package:rp_app/controllers/auth_controller.dart';
import 'package:rp_app/controllers/bank_controller.dart';
import 'package:rp_app/controllers/buy_rp_controller.dart';
import 'package:rp_app/controllers/buy_rp_history_controller.dart';
import 'package:rp_app/controllers/change_password_controller.dart';
import 'package:rp_app/controllers/forgot_password_controller.dart';
import 'package:rp_app/controllers/home_controller.dart';
import 'package:rp_app/controllers/profile_controller.dart';
import 'package:rp_app/controllers/sell_rp_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<BuyRPController>(() => BuyRPController(), fenix: true);
    Get.lazyPut<SellRPController>(() => SellRPController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}

class BuyRPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyRPController>(() => BuyRPController(), fenix: true);
    Get.lazyPut<BuyRPHistoryController>(
      () => BuyRPHistoryController(),
      fenix: true,
    );
  }
}

class ManageBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageBankController>(
      () => ManageBankController(),
      fenix: true,
    );
  }
}

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
      fenix: true,
    );
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(),
      fenix: true,
    );
  }
}
