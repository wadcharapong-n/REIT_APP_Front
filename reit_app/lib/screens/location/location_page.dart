import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import "package:google_maps_webservice/places.dart";

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  Position _position;
  final places =
      new GoogleMapsPlaces(apiKey: "AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y");

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  @override
  void initState() {
    super.initState();
    _initLocationState();
  }

  Future<void> _initLocationState() async {
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      await geolocator.getCurrentPosition();
      Stream<Position> positionStream = geolocator.getPositionStream(
          LocationOptions(
              accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 0));
      positionStream
          .listen((Position position) => setState(() => _position = position));
    } on PlatformException {}
  }

  Future<void> placesSearch(double latitude, double longitude) async {
    List placesList = List();
    PlacesSearchResponse reponse = await places.searchNearbyWithRadius(
      Location(latitude, longitude),
      25,
    );

    if (reponse.isOkay) {
      reponse.results.forEach((PlacesSearchResult place) {
        print(place.reference);
        placesList.add(place);
      });
    }

    for (var place in placesList) {
      PlacesDetailsResponse details =
          await places.getDetailsByReference(place.reference, language: 'th');
      _addMarker(details);
    }
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _addMarker(PlacesDetailsResponse place) {
    final String markerIdVal = LatLng(place.result.geometry.location.lat,
            place.result.geometry.location.lng)
        .toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(place.result.geometry.location.lat,
          place.result.geometry.location.lng),
      infoWindow: InfoWindow(
        title: place.result.name,
        snippet: place.result.formattedAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _removeMarker() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _onCameraMove(CameraPosition position) {}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.disabled ||
              snapshot.data == GeolocationStatus.denied) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: (snapshot.data == GeolocationStatus.disabled)
                    ? Text(
                        'GPS Disabled',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'GPS Denied',
                        style: TextStyle(color: Colors.black),
                      ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _initLocationState();
                    },
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Map',
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.orange[600],
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.black,
                  onPressed: () {
                    _initLocationState();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, '/MapSearch').then((result) {
                      PlacesDetailsResponse place = result;
                      mapController.moveCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 270.0,
                            target: LatLng(place.result.geometry.location.lat,
                                place.result.geometry.location.lng),
                            tilt: 30.0,
                            zoom: 17.0,
                          ),
                        ),
                      );
                      _addMarker(place);
                    });
                  },
                ),
              ],
            ),
            body: (_position != null)
                ? Stack(
                    children: <Widget>[
                      GoogleMap(
                        myLocationEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          bearing: 270.0,
                          target:
                              LatLng(_position.latitude, _position.longitude),
                          tilt: 30.0,
                          zoom: 15.0,
                        ),
                        mapType: _currentMapType,
                        markers: Set<Marker>.of(markers.values),
                        onCameraMove: _onCameraMove,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 70, 12, 0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: 38,
                                height: 38,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.white,
                                  onPressed: () {
                                    _removeMarker();
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  child: Icon(
                                    Icons.remove,
                                    size: 10.0,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.0),
                              SizedBox(
                                width: 38,
                                height: 38,
                                child: RaisedButton(
                                  padding: const EdgeInsets.all(0.0),
                                  color: Colors.white,
                                  onPressed: () {
                                    placesSearch(_position.latitude,
                                        _position.longitude);
                                  },
                                  child: Icon(
                                    Icons.add_location,
                                    size: 20.0,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          );
        });
  }
}
