class ProfileModel {
  final String name;
  final String phone;
  final double balance;

  ProfileModel({
    required this.name,
    required this.phone,
    required this.balance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: (json['name'] == null || json['name'].toString().isEmpty)
          ? "User"
          : json['name'],
      phone: json['phone'] ?? "",
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
