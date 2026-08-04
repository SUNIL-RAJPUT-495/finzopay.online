class RegisterModel {
  final String id;
  final String? email; // ✅ nullable
  final String role;
  final String token;

  RegisterModel({
    required this.id,
    this.email, // ✅ optional
    required this.role,
    required this.token,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'],
      email: json['email'], // may be null
      role: json['role'],
      token: json['token'],
    );
  }
}
