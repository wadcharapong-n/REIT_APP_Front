class ReitFavorite {
  final String userId;
  final String symbol;
  final String trustNameTh;
  final String trustNameEn;
  final String priceOfDay;
  final String maxPriceOfDay;
  final String minPriceOfDay;

  const ReitFavorite({
    this.userId,
    this.symbol,
    this.trustNameTh,
    this.trustNameEn,
    this.priceOfDay,
    this.maxPriceOfDay,
    this.minPriceOfDay,
  });

  factory ReitFavorite.fromJson(Map<String, dynamic> json) {
    var listReitItem = json['ReitItem'] as List;
    List<ReitItem> reitItems =
        listReitItem.map((i) => ReitItem.fromJson(i)).toList();
    return ReitFavorite(
      userId: json['UserId'],
      symbol: json['Symbol'],
      trustNameTh: reitItems[0].trustNameTh,
      trustNameEn: reitItems[0].trustNameEn,
      priceOfDay: reitItems[0].priceOfDay,
      maxPriceOfDay: reitItems[0].maxPriceOfDay,
      minPriceOfDay: reitItems[0].minPriceOfDay,
    );
  }
}

class ReitItem {
  final String trustNameTh;
  final String trustNameEn;
  final String priceOfDay;
  final String maxPriceOfDay;
  final String minPriceOfDay;

  ReitItem({
    this.trustNameTh,
    this.trustNameEn,
    this.priceOfDay,
    this.maxPriceOfDay,
    this.minPriceOfDay,
  });

  factory ReitItem.fromJson(Map<String, dynamic> json) {
    return ReitItem(
        trustNameTh: json['TrustNameTh'],
        trustNameEn: json['TrustNameEn'],
        priceOfDay: json['PriceOfDay'],
        maxPriceOfDay: json['MaxPriceOfDay'],
        minPriceOfDay: json['MinPriceOfDay']);
  }
}
