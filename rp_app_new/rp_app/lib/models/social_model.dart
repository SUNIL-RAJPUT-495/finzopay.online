class SocialModel {

  final String supportTelegram;
  final String supportWhatsapp;

  final String officialTelegram;
  final String officialWhatsapp;

  SocialModel({
    required this.supportTelegram,
    required this.supportWhatsapp,
    required this.officialTelegram,
    required this.officialWhatsapp,
  });

  factory SocialModel.fromJson(Map<String,dynamic> json){
    return SocialModel(
      supportTelegram: json['supportTelegram'] ?? "",
      supportWhatsapp: json['supportWhatsapp'] ?? "",
      officialTelegram: json['officialTelegram'] ?? "",
      officialWhatsapp: json['officialWhatsapp'] ?? "",
    );
  }
}
