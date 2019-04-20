class FavoriteReit {
  final String userId;
  final String symbol;
  final String trustNameTh;
  final String trustNameEn;
  final String priceOfDay;
  final String maxPriceOfDay;
  final String minPriceOfDay;

  const FavoriteReit({
    this.userId,
    this.symbol,
    this.trustNameTh,
    this.trustNameEn,
    this.priceOfDay,
    this.maxPriceOfDay,
    this.minPriceOfDay,
  });

  factory FavoriteReit.fromJson(Map<String, dynamic> json) {
    var listReitItem = json['Reit'] as List;
    List<ReitItem> reitItems =
        listReitItem.map((i) => ReitItem.fromJson(i)).toList();
    return FavoriteReit(
      userId: json['userId'],
      symbol: json['symbol'],
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
        trustNameTh: json['trustNameTh'],
        trustNameEn: json['trustNameEn'],
        priceOfDay: json['priceOfDay'],
        maxPriceOfDay: json['maxPriceOfDay'],
        minPriceOfDay: json['minPriceOfDay']);
  }
}
