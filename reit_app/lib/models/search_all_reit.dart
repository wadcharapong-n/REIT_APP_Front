class SearchAllReit {
  final String id;
  final String symbol;
  final String name;

  SearchAllReit({
    this.id,
    this.symbol,
    this.name,
  });

  factory SearchAllReit.fromJson(Map<String, dynamic> parsedJson) {
    return new SearchAllReit(
      id: parsedJson['id'],
      symbol: parsedJson['symbol'],
      name: parsedJson['name'],
    );
  }
}
