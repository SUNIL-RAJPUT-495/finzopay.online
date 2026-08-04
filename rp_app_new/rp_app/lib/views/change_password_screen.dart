import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/controllers/change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  // Colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
                _changePasswordCard(
                  context,
                  currentPasswordController,
                  newPasswordController,
                  confirmPasswordController,
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

  // ================= CHANGE PASSWORD CARD =================
  Widget _changePasswordCard(
    BuildContext context,
    TextEditingController currentPasswordController,
    TextEditingController newPasswordController,
    TextEditingController confirmPasswordController,
  ) {
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
                    "Change Password 🔐",
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
              "Update your account password",
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 30),

            _inputField(
              controller: currentPasswordController,
              label: "Current Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            _inputField(
              controller: newPasswordController,
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

            const SizedBox(height: 10),

            // Password requirements hint
            const Text(
              "Password must be at least 6 characters",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 25),

            /// CHANGE PASSWORD BUTTON
            Obx(() {
              return _gradientButton(
                text: controller.isLoading.value
                    ? "Changing..."
                    : "Change Password",
                isLoading: controller.isLoading.value,
                onTap: () async {
                  // Validation
                  if (currentPasswordController.text.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter your current password",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                    return;
                  }

                  if (newPasswordController.text.length < 6) {
                    Get.snackbar(
                      "Error",
                      "New password must be at least 6 characters",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                    return;
                  }

                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    Get.snackbar(
                      "Error",
                      "New passwords do not match",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                    return;
                  }

                  if (currentPasswordController.text ==
                      newPasswordController.text) {
                    Get.snackbar(
                      "Error",
                      "New password must be different from current password",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                    return;
                  }

                  FocusManager.instance.primaryFocus?.unfocus();

                  final success = await controller.changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );

                  if (success) {
                    Get.snackbar(
                      "Success",
                      "Password changed successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade100,
                      duration: const Duration(seconds: 2),
                    );

                    // Go back to profile screen
                    await Future.delayed(const Duration(seconds: 1));
                    Get.back();
                  } else {
                    Get.snackbar(
                      "Error",
                      controller.errorMessage.value.replaceAll(
                        'Exception: ',
                        '',
                      ),
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
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
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
