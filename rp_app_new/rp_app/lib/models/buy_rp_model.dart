class BuyRPModel {
  final String id;
  final String paymentId;
  final double paymentAmount;
  final String status;
  final double baseRp;
  final double commissionRp;
  final double totalRp;
  final DateTime createdAt;

  BuyRPModel({
    required this.id,
    required this.paymentId,
    required this.paymentAmount,
    required this.status,
    required this.baseRp,
    required this.commissionRp,
    required this.totalRp,
    required this.createdAt,
  });

  factory BuyRPModel.fromJson(Map<String, dynamic> json) {
    return BuyRPModel(
      id: json['id'],
      paymentId: json['payment_id'],
      paymentAmount: (json['payment_amount'] as num).toDouble(),
      status: json['status'],
      baseRp: double.tryParse(json['rp_received']['base_rp'].toString()) ?? 0.0,
      commissionRp:
          double.tryParse(json['rp_received']['commission_rp'].toString()) ??
          0.0,
      totalRp:
          double.tryParse(json['rp_received']['total_rp'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
