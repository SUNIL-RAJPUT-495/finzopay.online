import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rp_app/routes/app_routes.dart';
import 'package:rp_app/views/login_screen.dart';
import 'package:rp_app/services/auth_service.dart';
import 'package:rp_app/models/registration_success_model.dart';
import 'package:rp_app/utils/token_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobile = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirm = TextEditingController();
  final TextEditingController invite = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final TextEditingController email = TextEditingController();

  bool isOtpSent = false;

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF0D47A1);

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Center(
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
                        Icons.person_add_alt_1_rounded,
                        size: 50,
                        color: primaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: darkBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Fill your details to get started",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),

                            const SizedBox(height: 30),

                            if (!isOtpSent) ...[
                              _inputField(
                                controller: mobile,
                                label: "Mobile Number",
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "Mobile number is required";
                                  if (v.length != 10) return "Enter valid 10-digit number";
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _inputField(
                                controller: invite,
                                label: "Invite Code",
                                icon: Icons.card_giftcard,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "Invite code is required";
                                  return null;
                                },
                              ),
                            ] else ...[
                              _inputField(
                                controller: mobile,
                                label: "Mobile Number",
                                icon: Icons.phone,
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "Mobile number is required";
                                  if (v.length != 10) return "Enter valid 10-digit number";
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _inputField(
                                controller: otp,
                                label: "OTP",
                                icon: Icons.message,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "OTP is required";
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () async {
                                    try {
                                      await _authService.registerSendOtp(
                                        phone: mobile.text,
                                        inviteCode: invite.text,
                                      );
                                      _showToast("OTP Resent Successfully!");
                                    } catch (e) {
                                      _showToast(e.toString().replaceAll('Exception: ', ''));
                                    }
                                  },
                                  child: const Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                      color: primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _inputField(
                                controller: email,
                                label: "Email (Optional)",
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _inputField(
                                controller: pass,
                                label: "Password",
                                icon: Icons.lock,
                                isPassword: true,
                                showPassword: _showPassword,
                                toggle: () => setState(() => _showPassword = !_showPassword),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "Password is required";
                                  if (v.length < 6) return "Minimum 6 characters required";
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _inputField(
                                controller: confirm,
                                label: "Confirm Password",
                                icon: Icons.lock_outline,
                                isPassword: true,
                                showPassword: _showConfirmPassword,
                                toggle: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "Confirm your password";
                                  if (v != pass.text) return "Passwords do not match";
                                  return null;
                                },
                              ),
                            ],

                            const SizedBox(height: 30),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: isLoading
                                        ? Colors.grey.withOpacity(0.2)
                                        : primaryBlue.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: isLoading
                                      ? [Colors.grey.shade400, Colors.grey.shade500]
                                      : [primaryBlue, darkBlue],
                                ),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          if (!_formKey.currentState!.validate()) {
                                            _showToast("Please fill all required fields");
                                            return;
                                          }

                                          setState(() => isLoading = true);

                                          try {
                                            if (!isOtpSent) {
                                              await _authService.registerSendOtp(
                                                phone: mobile.text,
                                                inviteCode: invite.text,
                                              );
                                              setState(() {
                                                isOtpSent = true;
                                              });
                                              _showToast("OTP sent successfully!");
                                            } else {
                                              final response = await _authService.registerVerifyOtp(
                                                phone: mobile.text,
                                                otp: otp.text,
                                                password: pass.text,
                                                email: email.text,
                                              );
                                              
                                              final user = RegistrationSuccessModel.fromJson(response);
                                              
                                              if (user.success && user.token.isNotEmpty) {
                                                await TokenStorage.saveToken(user.token);
                                                Get.offAllNamed(Routes.home);
                                              } else {
                                                _showToast(user.message.isNotEmpty ? user.message : 'Registration failed');
                                              }
                                            }
                                          } catch (e) {
                                            _showToast(e.toString().replaceAll('Exception: ', ''));
                                          } finally {
                                            FocusScope.of(context).unfocus();
                                            setState(() => isLoading = false);
                                          }
                                        },
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
                                              isOtpSent ? "Verifying..." : "Sending...",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          isOtpSent ? "Verify & Register" : "Send OTP",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: const Color(
                                      0xFF6A11CB,
                                    ).withOpacity(0.8),
                                    width: 1.6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6A11CB),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool showPassword = false,
    bool readOnly = false,
    VoidCallback? toggle,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      obscureText: isPassword && !showPassword,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        labelStyle: const TextStyle(color: primaryBlue),
        prefixIcon: Icon(icon, color: primaryBlue),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: primaryBlue,
                ),
                onPressed: toggle,
              )
            : null,
        filled: true,
        fillColor: lightBlue.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
      ),
    );
  }
}
