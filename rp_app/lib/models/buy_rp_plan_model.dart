class BuyRPPlanModel {
  final String id;
  final int rpAmount;
  final int price;
  final int commissionPercent;

  BuyRPPlanModel({
    required this.id,
    required this.rpAmount,
    required this.price,
    required this.commissionPercent,
  });

  factory BuyRPPlanModel.fromJson(Map<String, dynamic> json) {
    return BuyRPPlanModel(
      id: json['_id'] ?? "",
      rpAmount: (json['rp_amount'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt() ?? 0,
      commissionPercent: (json['commission_percent'] as num?)?.toInt() ?? 0,
    );
  }
}

class WalletModel {
  final double totalRp;
  final double lockedRp;
  final double availableRp;

  WalletModel({
    required this.totalRp,
    required this.lockedRp,
    required this.availableRp,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      totalRp: (json['total_rp'] as num?)?.toDouble() ?? 0.0,
      lockedRp: (json['locked_rp'] as num?)?.toDouble() ?? 0.0,
      availableRp: (json['available_rp'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
