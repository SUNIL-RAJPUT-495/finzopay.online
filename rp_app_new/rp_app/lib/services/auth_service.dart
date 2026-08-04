import 'dart:developer';

import 'package:rp_app/models/profile_model.dart';

import '../models/register_model.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// REGISTER: SEND OTP
  Future<void> registerSendOtp({
    required String phone,
    required String inviteCode,
  }) async {
    await _apiService.post(
      "/auth/register/send-otp",
      {
        "phone": phone,
        "inviteCode": inviteCode,
      },
      timeout: const Duration(seconds: 20),
    );
  }

  /// REGISTER: VERIFY OTP
  Future<Map<String, dynamic>> registerVerifyOtp({
    required String phone,
    required String otp,
    required String password,
    required String email,
  }) async {
    final response = await _apiService.post(
      "/auth/register/verify-otp",
      {
        "phone": phone,
        "otp": otp,
        "password": password,
        "email": email,
      },
      timeout: const Duration(seconds: 20),
    );

    log("registerVerifyOtp res $response");
    return response;
  }

  /// STEP 1: SEND OTP
  Future<void> sendOtp({
    required String phone,
    required String password,
  }) async {
    await _apiService.post(
      "/auth/login",
      {"phone": phone, "password": password},
      timeout: const Duration(seconds: 20), // Custom timeout for login
    );
  }

  /// STEP 2: VERIFY OTP
  Future<RegisterModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _apiService.post(
      "/auth/login-otp",
      {"phone": phone, "otp": otp},
      timeout: const Duration(
        seconds: 15,
      ), // Custom timeout for OTP verification
    );

    return RegisterModel.fromJson(response['data']);
  }

  /// RESEND OTP (for OTP screen)
  Future<void> resendOtp({required String phone}) async {
    // Typically, resend OTP would use a dedicated endpoint
    // If your backend has /auth/resend-otp, use that
    // For now, we'll use a placeholder that can be updated
    await _apiService.post("/auth/resend-otp", {
      "phone": phone,
    }, timeout: const Duration(seconds: 20));
  }

  Future<ProfileModel> getProfile() async {
    final res = await _apiService.get(
      "/auth/profile",
      useCache: true,
      cacheMaxAge: const Duration(minutes: 2), // Cache profile for 2 minutes
    );
    return ProfileModel.fromJson(res['data']);
  }

  /// FORGOT PASSWORD: SEND OTP
  Future<void> sendForgotPasswordOtp({required String phone}) async {
    await _apiService.post("/auth/forgot-password/send-otp", {
      "phone": phone,
    }, timeout: const Duration(seconds: 20));
  }

  /// FORGOT PASSWORD: RESET PASSWORD
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await _apiService.post("/auth/forgot-password/reset", {
      "phone": phone,
      "otp": otp,
      "newPassword": newPassword,
    }, timeout: const Duration(seconds: 20));
  }

  /// CHANGE PASSWORD (for logged-in users)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _apiService.post("/auth/change-password", {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    }, timeout: const Duration(seconds: 20));
  }
}
