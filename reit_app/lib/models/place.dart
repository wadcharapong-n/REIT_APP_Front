import 'package:reit_app/models/reit_detail.dart';

class Place {
  final String symbol;
  final String name;
  final String address;
  final Coordinates location;
  final List<ReitDetail> reit;

  const Place({
    this.symbol,
    this.name,
    this.address,
    this.location,
    this.reit,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    List<ReitDetail> reitItem;
    Coordinates location = Coordinates.fromJson(json['location']);
    if (json['Reit'] != null) {
      var jsonReit = json['Reit'] as List;
      reitItem = jsonReit.map((i) => ReitDetail.fromJson(i)).toList();
    } else {
      reitItem = null;
    }
    return Place(
      symbol: json['symbol'],
      name: json['name'],
      address: json['address'],
      location: location,
      reit: reitItem,
    );
  }
}

class Coordinates {
  final longitude;
  final latitude;

  Coordinates({
    this.longitude,
    this.latitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] == null) {
      return Coordinates(
        longitude: null,
        latitude: null,
      );
    }
    return Coordinates(
      longitude: json['coordinates'][0],
      latitude: json['coordinates'][1],
    );
  }
}
