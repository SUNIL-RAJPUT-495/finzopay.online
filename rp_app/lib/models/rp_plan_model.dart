class RPPlanModel {
  final String id;
  final int price;
  final int rpAmount;
  final int commissionPercent;

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
      commissionPercent: json['commission_percent'],
    );
  }

  int get commissionRp =>
      ((rpAmount * commissionPercent) / 100).round();

  int get finalRp => rpAmount + commissionRp;
}
