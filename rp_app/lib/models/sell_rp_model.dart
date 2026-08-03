class SellRPModel {
  final String id;
  final int rpSold;
  final int amount;
  final String status;
  final String bankName;
  final String accountLast4;

  SellRPModel({
    required this.id,
    required this.rpSold,
    required this.amount,
    required this.status,
    required this.bankName,
    required this.accountLast4,
  });

  factory SellRPModel.fromJson(Map<String, dynamic> json) {
    final bankMap = json['bank'] as Map<String, dynamic>?;
    return SellRPModel(
      id: json['id'] ?? "",
      rpSold: (json['rp_sold'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      status: json['status'] ?? "pending",
      bankName: bankMap?['bank_name'] ?? "N/A",
      accountLast4: bankMap?['account_last4'] ?? "N/A",
    );
  }
}
