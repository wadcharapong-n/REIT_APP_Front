class Reit {
  final String id;
  final String symbol;
  final String trustNameTh;
  final String trustNameEn;

  const Reit({
    this.id,
    this.symbol,
    this.trustNameTh,
    this.trustNameEn,
  });

  factory Reit.fromJson(Map<String, dynamic> json) {
    return Reit(
      id: json['ID'],
      symbol: json['Symbol'],
      trustNameTh: json['TrustNameTh'],
      trustNameEn: json['TrustNameEn'],
    );
  }
}
