class Reit {
  final String id;
  final String symbol;
  final String name;
  final String price;
  final String description;

  const Reit({
    this.id,
    this.symbol,
    this.name,
    this.price,
    this.description,
  });

  factory Reit.fromJson(Map<String, dynamic> json) {
    return Reit(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
    );
  }
}
