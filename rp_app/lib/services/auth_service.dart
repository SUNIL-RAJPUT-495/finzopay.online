import 'package:rp_app/models/profile_model.dart';

import '../models/register_model.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// REGISTER USER
  Future<Map<String, dynamic>> register({
    String? email, // optional
    required String phone,
    required String password,
    required String inviteCode, // required
  }) async {
    final response = await _apiService.post("/auth/register", {
      if (email != null && email.isNotEmpty) "email": email,
      "phone": phone,
      "password": password,
      "inviteCode": inviteCode,
    });

    return response['data'];
  }

  /// STEP 1: SEND OTP
  Future<void> sendOtp({
    required String phone,
    required String password,
  }) async {
    await _apiService.post("/auth/login", {
      "phone": phone,
      "password": password,
    });
  }

  /// STEP 2: VERIFY OTP
  Future<RegisterModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _apiService.post("/auth/login-otp", {
      "phone": phone,
      "otp": otp,
    });

    return RegisterModel.fromJson(response['data']);
  }

  Future<ProfileModel> getProfile() async {
    final res = await _apiService.get("/auth/profile");
    return ProfileModel.fromJson(res['data']);
  }
}
