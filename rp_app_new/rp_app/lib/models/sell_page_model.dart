class SellRPResponse {
  final Balance balance;
  final BankData bank;

  SellRPResponse({required this.balance, required this.bank});

  factory SellRPResponse.fromJson(Map<String, dynamic> json) {
    return SellRPResponse(
      balance: Balance.fromJson(json['balance']),
      bank: BankData.fromJson(json['bank']),
    );
  }
}

// ================= BALANCE =================
class Balance {
  final double totalRp;
  final double lockedRp;
  final double availableRp;

  const Balance({
    required this.totalRp,
    required this.lockedRp,
    required this.availableRp,
  });

  factory Balance.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Balance(totalRp: 0.0, lockedRp: 0.0, availableRp: 0.0);
    }

    return Balance(
      totalRp: _toDouble(json['total_rp']),
      lockedRp: _toDouble(json['locked_rp']),
      availableRp: _toDouble(json['available_rp']),
    );
  }

  /// Safe converter
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_rp': totalRp,
      'locked_rp': lockedRp,
      'available_rp': availableRp,
    };
  }
}

// ================= BANK DATA =================
class BankData {
  final bool hasBank;
  final String? message;
  final List<BankAccount> list;

  BankData({required this.hasBank, this.message, required this.list});

  factory BankData.fromJson(Map<String, dynamic> json) {
    return BankData(
      hasBank: json['hasBank'],
      message: json['message'],
      list: json['list'] == null
          ? []
          : (json['list'] as List).map((e) => BankAccount.fromJson(e)).toList(),
    );
  }
}

// ================= BANK ACCOUNT =================
class BankAccount {
  final String id;
  final String bankName;
  final String accountHolder;
  final String accountNumber;
  final String ifsc;
  final bool isDefault;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountHolder,
    required this.accountNumber,
    required this.ifsc,
    required this.isDefault,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['_id'],
      bankName: json['bank_name'],
      accountHolder: json['account_holder'],
      accountNumber: json['account_number'],
      ifsc: json['ifsc'],
      isDefault: json['is_default'],
    );
  }
}
