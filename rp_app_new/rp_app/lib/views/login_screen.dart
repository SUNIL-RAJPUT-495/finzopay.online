import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/auth_controller.dart';
import 'package:rp_app/routes/app_routes.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  // Colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF0D47A1);

  final TextEditingController mobile = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _topIcon(),
                const SizedBox(height: 30),
                _loginCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TOP ICON =================
  Widget _topIcon() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          Icons.lock_open_rounded,
          size: 50,
          color: primaryBlue,
        ),
      ),
    );
  }

  // ================= LOGIN CARD =================
  Widget _loginCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please sign in to continue",
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 30),

            _inputField(
              controller: mobile,
              label: "Mobile Number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),

            const SizedBox(height: 20),

            _inputField(
              controller: password,
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),

            const SizedBox(height: 10),

            /// FORGOT PASSWORD LINK
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.forgotPassword);
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color(0xFF6A11CB),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// LOGIN BUTTON (Reactive)
            Obx(() {
              return _gradientButton(
                text: controller.isLoading.value ? "Sending OTP..." : "Login",
                isLoading: controller.isLoading.value,
                onTap: () async {
                  if (mobile.text.length != 10 || password.text.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Enter valid mobile number and password",
                    );
                    return;
                  }

                  FocusManager.instance.primaryFocus?.unfocus();

                  final success = await controller.sendOtp(
                    phone: mobile.text,
                    password: password.text,
                  );

                  if (success) {
                    Get.toNamed(Routes.otp, arguments: mobile.text);
                  } else {
                    Get.snackbar("Login Failed", controller.errorMessage.value);
                  }
                },
              );
            }),

            const SizedBox(height: 25),
            _divider(),
            const SizedBox(height: 25),

            /// REGISTER BUTTON
            OutlinedButton(
              onPressed: () {
                Get.toNamed(Routes.register);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: BorderSide(
                  color: const Color(0xFF6A11CB).withOpacity(0.8),
                  width: 1.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A11CB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        labelStyle: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: primaryBlue),
        filled: true,
        fillColor: lightBlue.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  // ================= GRADIENT BUTTON =================
  Widget _gradientButton({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isLoading
              ? [Colors.grey.shade400, Colors.grey.shade500]
              : [primaryBlue, darkBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: isLoading
                ? Colors.grey.withOpacity(0.2)
                : primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ================= DIVIDER =================
  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.blueGrey.withOpacity(0.3))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "or continue with",
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        Expanded(child: Divider(color: Colors.blueGrey.withOpacity(0.3))),
      ],
    );
  }
}
