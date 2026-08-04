import 'package:get/get.dart';
import 'package:rp_app/bindings/app_bindings.dart';
import 'package:rp_app/routes/app_routes.dart';
import 'package:rp_app/splash_screen.dart';
import 'package:rp_app/views/home_screen.dart';
import 'package:rp_app/views/login_screen.dart';
import 'package:rp_app/register_screen.dart';
import 'package:rp_app/views/otp_screen.dart';
import 'package:rp_app/views/buy_rp.dart';
import 'package:rp_app/views/manage_bank_page.dart';
import 'package:rp_app/views/forgot_password_screen.dart';
import 'package:rp_app/views/change_password_screen.dart';
import 'package:rp_app/views/payment_web_view_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => OtpScreen(phone: Get.arguments ?? ''),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.buyRpHistory,
      page: () => const BuyRPScreen(),
      binding: BuyRPBinding(),
    ),
    GetPage(
      name: Routes.addBank,
      page: () => ManageBankPage(),
      binding: ManageBankBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: Routes.paymentWebView,
      page: () => const PaymentWebViewPage(),
    ),
  ];
}
