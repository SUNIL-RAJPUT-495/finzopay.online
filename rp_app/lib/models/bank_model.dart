class BankAccount {
  final String id;
  final String holderName;
  final String bankName;
  final String accountNumber;
  final String ifsc;
  final bool isDefault;

  BankAccount({
    required this.id,
    required this.holderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.isDefault,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['_id'],
      holderName: json['account_holder'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      ifsc: json['ifsc'],
      isDefault: json['is_default'] ?? false,
    );
  }
}
