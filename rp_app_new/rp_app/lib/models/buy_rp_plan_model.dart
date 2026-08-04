class BuyRPPlanModel {
  final String id;
  final int rpAmount;
  final int price;
  final double commissionPercent;

  BuyRPPlanModel({
    required this.id,
    required this.rpAmount,
    required this.price,
    required this.commissionPercent,
  });

  factory BuyRPPlanModel.fromJson(Map<String, dynamic> json) {
    return BuyRPPlanModel(
      id: json['_id'],
      rpAmount: json['rp_amount'],
      price: json['price'],
      commissionPercent:
          double.tryParse("${json['commission_percent']}") ??
          0, // TODO: handle null
    );
  }
}

class WalletModel {
  final double totalRp;
  final double lockedRp;
  final double availableRp;

  const WalletModel({
    required this.totalRp,
    required this.lockedRp,
    required this.availableRp,
  });

  factory WalletModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WalletModel(totalRp: 0.0, lockedRp: 0.0, availableRp: 0.0);
    }

    return WalletModel(
      totalRp: _toDouble(json['total_rp']),
      lockedRp: _toDouble(json['locked_rp']),
      availableRp: _toDouble(json['available_rp']),
    );
  }

  /// Safe parser
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  /// Optional: convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_rp': totalRp,
      'locked_rp': lockedRp,
      'available_rp': availableRp,
    };
  }
}
