class HomeModel {
  final Wallet wallet;
  final double todayCommission;
  final TodayStats todayStats;
  final BankInfo? bank;
  final List<BannerModel> banners;

  HomeModel({
    required this.wallet,
    required this.todayCommission,
    required this.todayStats,
    required this.banners,
    this.bank,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return HomeModel(
      wallet: Wallet.fromJson(data['wallet']),
      todayCommission: (data['todayCommission'] ?? 0).toDouble(),
      todayStats: TodayStats.fromJson(data['todayStats']),
      bank: data['bank'] != null ? BankInfo.fromJson(data['bank']) : null,
      banners: (data['banners'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList(),
    );
  }
}

// ================= WALLET =================
class Wallet {
  final double totalBalance;
  final double lockedBalance;
  final double availableBalance;

  Wallet({
    required this.totalBalance,
    required this.lockedBalance,
    required this.availableBalance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      lockedBalance: (json['lockedBalance'] ?? 0).toDouble(),
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
    );
  }
}

// ================= BANK =================
class BankInfo {
  final bool hasBank;
  final String? message;
  final List<BankAccount> accounts;

  BankInfo({
    required this.hasBank,
    this.message,
    required this.accounts,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      hasBank: json['hasBank'] ?? false,
      message: json['message'],
      accounts: json['accounts'] != null
          ? (json['accounts'] as List)
          .map((e) => BankAccount.fromJson(e))
          .toList()
          : [],
    );
  }
}

class BankAccount {
  final String id;
  final String holder;
  final String bankName;
  final String accountNumber;
  final bool isDefault;

  BankAccount({
    required this.id,
    required this.holder,
    required this.bankName,
    required this.accountNumber,
    required this.isDefault,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['_id'],
      holder: json['account_holder'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      isDefault: json['is_default'] ?? false,
    );
  }
}

// ================= BANNERS =================
class BannerModel {
  final int id;
  final String image;

  BannerModel({required this.id, required this.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
    );
  }
}

// ================= STATS =================
class TodayStats {
  final int buyQuantity;
  final double buyAmount;
  final double sellToday;

  TodayStats({
    required this.buyQuantity,
    required this.buyAmount,
    required this.sellToday,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) {
    return TodayStats(
      buyQuantity: json['buyQuantity'] ?? 0,
      buyAmount: (json['buyAmount'] ?? 0).toDouble(),
      sellToday: (json['sellToday'] ?? 0).toDouble(),
    );
  }
}
