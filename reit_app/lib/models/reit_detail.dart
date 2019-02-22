class ReitDetail {
  final String id;
  final String symbol;
  final String nameThai;
  final String nameEng;
  final double price;
  final double highestPrice;
  final double lowestPrice;
  final double parValue;
  final double pNav;
  final double pe;
  final double ceilingPrice;
  final double floorPrice;
  final String dividendPolicy;
  final String trustee;

  const ReitDetail({
    this.id,
    this.symbol,
    this.nameThai,
    this.nameEng,
    this.price,
    this.highestPrice,
    this.lowestPrice,
    this.parValue,
    this.pNav,
    this.pe,
    this.ceilingPrice,
    this.floorPrice,
    this.dividendPolicy,
    this.trustee
  });

  factory ReitDetail.fromJson(Map<String, dynamic> json) {
    return ReitDetail(
      id: json['id'],
      symbol: json['symbol'],
      nameThai: json['nameThai'],
      nameEng: json['nameEng'],
      price: json['price'],
      highestPrice: json['highestPrice'],
      lowestPrice: json['lowestPrice'],
      parValue: json['parValue'],
      pNav: json['pNav'],
      pe: json['pe'],
      ceilingPrice: json['ceilingPrice'],
      floorPrice: json['floorPrice'],
      dividendPolicy: json['dividendPolicy'],
      trustee: json['trustee'],
    );
  }
}
