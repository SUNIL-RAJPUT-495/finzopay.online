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

  Balance({
    required this.totalRp,
    required this.lockedRp,
    required this.availableRp,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      totalRp: (json['total_rp'] as num).toDouble(),
      lockedRp: (json['locked_rp'] as num).toDouble(),
      availableRp: (json['available_rp'] as num).toDouble(),
    );
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
