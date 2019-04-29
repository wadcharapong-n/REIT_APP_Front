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
  final String urlAddress;
  final List<MajorShareholders> majorShareholders;

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
    this.urlAddress,
    this.majorShareholders,
  });

  String handledNullString(String value) => value == null ? "" : value;

  factory ReitDetail.fromJson(Map<String, dynamic> json) {
    var jsonMajorShareholders = json['majorShareholders'] as List;
    List<MajorShareholders> majorShareholdersItems = jsonMajorShareholders
        .map((i) => MajorShareholders.fromJson(i))
        .toList();
    return ReitDetail(
      id: json['id'],
      symbol: json['symbol'],
      trustNameTh: json['trustNameTh'],
      trustNameEn: json['trustNameEn'],
      priceOfDay: json['priceOfDay'],
      maxPriceOfDay: json['maxPriceOfDay'],
      minPriceOfDay: json['minPriceOfDay'],
      parValue: json['parValue'],
      parNAV: json['parNAV'],
      peValue: json['peValue'],
      ceilingValue: json['ceilingValue'],
      floorValue: json['floorValue'],
      policy: json['policy'],
      trustee: json['trustee'],
      nickName: json['nickName'],
      reitManager: json['reitManager'],
      address: json['address'],
      registrationDate: json['registrationDate'],
      investmentAmount: json['investmentAmount'],
      establishmentDate: json['establishmentDate'],
      urlAddress: json['url'],
      majorShareholders: majorShareholdersItems,
    );
  }
}

class MajorShareholders {
  final String symbol;
  final String nameTh;
  final String nameEn;
  final String shares;
  final String sharesPercent;

  MajorShareholders({
    this.symbol,
    this.nameTh,
    this.nameEn,
    this.shares,
    this.sharesPercent,
  });

  factory MajorShareholders.fromJson(Map<String, dynamic> json) {
    return MajorShareholders(
        symbol: json['symbol'],
        nameTh: json['nameTh'],
        nameEn: json['nameEn'],
        shares: json['shares'],
        sharesPercent: json['sharesPercent']);
  }
}
