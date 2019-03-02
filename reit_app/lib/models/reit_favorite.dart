class ReitFavorite {
  final String userId;
  final String ticker;

  const ReitFavorite({
    this.userId,
    this.ticker,
  });

  factory ReitFavorite.fromJson(Map<String, dynamic> json) {
    return ReitFavorite(
      userId: json['UserId'],
      ticker: json['Ticker'],
    );
  }
}
