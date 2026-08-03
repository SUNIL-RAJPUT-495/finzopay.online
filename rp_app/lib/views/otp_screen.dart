import 'package:flutter/material.dart';
import 'package:rp_app/views/home_screen.dart';
import 'package:rp_app/services/auth_service.dart';
import 'package:rp_app/models/register_model.dart';
import 'package:rp_app/utils/token_storage.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthService _authService = AuthService();

  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());

  bool isLoading = false;

  String _getOtp() {
    return _otpControllers.map((e) => e.text).join();
  }

  Widget otpBox(BuildContext context, int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1976D2),
        ),
        cursorColor: const Color(0xFF1976D2),
        onChanged: (v) {
          if (v.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF90CAF9),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF1976D2),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }

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
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(height: 30),

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
                      Icons.sms_outlined,
                      size: 50,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // OTP Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Enter the 4-digit code sent to your mobile number",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // OTP Boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < 4; i++)
                              otpBox(context, i),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Timer
                        const Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Resend OTP in ",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "59",
                                  style: TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "s",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Verify Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1976D2)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1976D2),
                                Color(0xFF0D47A1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                final otp = _getOtp();
                                print("OTP"+otp);

                                if (otp.length != 4) {
                                  _showToast("Enter valid OTP");
                                  return;
                                }

                                FocusScope.of(context).unfocus();

                                try {
                                  setState(() => isLoading = true);

                                  final RegisterModel user =
                                  await _authService.verifyOtp(
                                    phone: widget.phone,
                                    otp: otp,
                                  );

                                  await TokenStorage.saveToken(user.token);

                                  if (!mounted) return;

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HomeScreen(),
                                    ),
                                        (route) => false,
                                  );
                                } catch (e) {
                                  _showToast(e.toString());
                                } finally {
                                  setState(() => isLoading = false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isLoading ? "Verifying..." : "Verify OTP",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Resend OTP
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Didn't receive code? Resend",
                              style: TextStyle(
                                color: Color(0xFF1976D2),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
