class RegistrationSuccessModel {
  final bool success;
  final String message;
  final String token;

  RegistrationSuccessModel({
    required this.success,
    required this.message,
    required this.token,
  });

  factory RegistrationSuccessModel.fromJson(Map<String, dynamic> json) {
    return RegistrationSuccessModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
