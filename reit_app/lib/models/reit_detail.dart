class ReitDetail {
  final String id;
  final String symbol;
  final String trustNameTh;
  final String trustNameEn;
  final String priceOfDay;
  final String maxPriceOfDay;
  final String minPriceOfDay;
  final String parValue;
  final String parNAV;
  final String peValue;
  final String ceilingValue;
  final String floorValue;
  final String policy;
  final String trustee;
  final String nickName;
  final String reitManager;
  final String address;
  final String registrationDate;
  final String investmentAmount;
  final String establishmentDate;

  const ReitDetail({
    this.id,
    this.symbol,
    this.trustNameTh,
    this.trustNameEn,
    this.priceOfDay,
    this.maxPriceOfDay,
    this.minPriceOfDay,
    this.parValue,
    this.parNAV,
    this.peValue,
    this.ceilingValue,
    this.floorValue,
    this.policy,
    this.trustee,
    this.nickName,
    this.reitManager,
    this.address,
    this.registrationDate,
    this.investmentAmount,
    this.establishmentDate,
  });

  String handledNullString(String value) => value == null ? "" : value;

  factory ReitDetail.fromJson(Map<String, dynamic> json) {
    return ReitDetail(
      id: json['Id'],
      symbol: json['Symbol'],
      trustNameTh: json['TrustNameTh'],
      trustNameEn: json['TrustNameEn'],
      priceOfDay: json['PriceOfDay'],
      maxPriceOfDay: json['MaxPriceOfDay'],
      minPriceOfDay: json['MinPriceOfDay'],
      parValue: json['ParValue'],
      parNAV: json['ParNAV'],
      peValue: json['PeValue'],
      ceilingValue: json['CeilingValue'],
      floorValue: json['FloorValue'],
      policy: json['Policy'],
      trustee: json['Trustee'],
      nickName: json['NickName'],
      reitManager: json['ReitManager'],
      address: json['Address'],
      registrationDate: json['RegistrationDate'],
      investmentAmount: json['InvestmentAmount'],
      establishmentDate: json['EstablishmentDate'],
    );
  }
}
