class BuyRPModel {
  final String id;
  final String paymentId;
  final double paymentAmount;
  final String status;
  final int baseRp;
  final int commissionRp;
  final int totalRp;
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
    final rpReceived = json['rp_received'];
    return BuyRPModel(
      id: json['id'] ?? "",
      paymentId: json['payment_id'] ?? "",
      paymentAmount: (json['payment_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? "pending",
      baseRp: rpReceived != null && rpReceived['base_rp'] != null
          ? (rpReceived['base_rp'] as num).toInt()
          : 0,
      commissionRp: rpReceived != null && rpReceived['commission_rp'] != null
          ? (rpReceived['commission_rp'] as num).toInt()
          : 0,
      totalRp: rpReceived != null && rpReceived['total_rp'] != null
          ? (rpReceived['total_rp'] as num).toInt()
          : 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
