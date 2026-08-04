import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/forgot_password_controller.dart';
import 'package:rp_app/routes/app_routes.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  // Colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF0D47A1);

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
                Obx(
                  () => controller.currentStep.value == 0
                      ? _phoneStep()
                      : _resetPasswordStep(),
                ),
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
          Icons.lock_reset_rounded,
          size: 50,
          color: primaryBlue,
        ),
      ),
    );
  }

  // ================= STEP 1: PHONE NUMBER =================
  Widget _phoneStep() {
    final phoneController = TextEditingController();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: darkBlue),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Forgot Password? 🔐",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your mobile number to receive OTP",
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 30),

            _inputField(
              controller: phoneController,
              label: "Mobile Number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),

            const SizedBox(height: 25),

            /// SEND OTP BUTTON
            Obx(() {
              return _gradientButton(
                text: controller.isLoading.value
                    ? "Sending OTP..."
                    : "Send OTP",
                isLoading: controller.isLoading.value,
                onTap: () async {
                  if (phoneController.text.length != 10) {
                    Get.snackbar(
                      "Error",
                      "Please enter a valid 10-digit mobile number",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  FocusManager.instance.primaryFocus?.unfocus();

                  final success = await controller.sendOtp(
                    phoneController.text,
                  );

                  if (success) {
                    Get.snackbar(
                      "Success",
                      "OTP sent successfully to ${phoneController.text}",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade100,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      controller.errorMessage.value,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= STEP 2: OTP & NEW PASSWORD =================
  Widget _resetPasswordStep() {
    final otpController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: darkBlue),
                  onPressed: () {
                    controller.resetState();
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Reset Password 🔑",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                "Enter OTP sent to ${controller.phone.value}",
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 30),

            _inputField(
              controller: otpController,
              label: "OTP",
              icon: Icons.pin,
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),

            const SizedBox(height: 20),

            _inputField(
              controller: passwordController,
              label: "New Password",
              icon: Icons.lock,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            _inputField(
              controller: confirmPasswordController,
              label: "Confirm New Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 25),

            /// RESET PASSWORD BUTTON
            Obx(() {
              return _gradientButton(
                text: controller.isLoading.value
                    ? "Resetting..."
                    : "Reset Password",
                isLoading: controller.isLoading.value,
                onTap: () async {
                  // Validation
                  if (otpController.text.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter OTP",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  if (passwordController.text.length < 6) {
                    Get.snackbar(
                      "Error",
                      "Password must be at least 6 characters",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    Get.snackbar(
                      "Error",
                      "Passwords do not match",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  FocusManager.instance.primaryFocus?.unfocus();

                  final success = await controller.resetPassword(
                    otp: otpController.text,
                    newPassword: passwordController.text,
                  );

                  if (success) {
                    Get.snackbar(
                      "Success",
                      "Password reset successfully! Please login with your new password.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade100,
                      duration: const Duration(seconds: 3),
                    );

                    // Navigate back to login
                    await Future.delayed(const Duration(seconds: 1));
                    Get.offAllNamed(Routes.login);
                  } else {
                    Get.snackbar(
                      "Error",
                      controller.errorMessage.value,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                  }
                },
              );
            }),
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
}
