class RPPlanModel {
  final String id;
  final int price;
  final int rpAmount;
  final double commissionPercent;

  RPPlanModel({
    required this.id,
    required this.price,
    required this.rpAmount,
    required this.commissionPercent,
  });

  factory RPPlanModel.fromJson(Map<String, dynamic> json) {
    return RPPlanModel(
      id: json['_id'],
      price: json['price'],
      rpAmount: json['rp_amount'],
      commissionPercent:
          double.tryParse("${json['commission_percent']}") ??
          0, // TODO: handle null
    );
  }

  int get commissionRp => ((rpAmount * commissionPercent) / 100).round();

  int get finalRp => rpAmount + commissionRp;
}
