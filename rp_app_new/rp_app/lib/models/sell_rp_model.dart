class SellRPModel {
  final String id;
  final double rpSold;
  final double amount;
  final String status;
  final String? bankName;
  final String? accountLast4;
  final DateTime? requestedAt;

  SellRPModel({
    required this.id,
    required this.rpSold,
    required this.amount,
    required this.status,
    this.bankName,
    this.accountLast4,
    this.requestedAt,
  });

  factory SellRPModel.fromJson(Map<String, dynamic> json) {
    final bank = json['bank'] as Map<String, dynamic>?;

    return SellRPModel(
      id: json['id']?.toString() ?? '',

      rpSold: _parseDouble(json['rp_sold']),
      amount: _parseDouble(json['amount']),

      status: json['status']?.toString() ?? '',

      bankName: _parseString(bank?['bank_name']),
      accountLast4: _parseString(bank?['account_last4']),

      requestedAt: _parseDate(json['requestedAt']),
    );
  }

  /// Safe double parser
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Safe Date parser
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
