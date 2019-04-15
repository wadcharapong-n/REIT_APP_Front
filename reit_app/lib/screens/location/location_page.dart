import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reit_app/app_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/places.dart";

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController mapController;
  Position _position;
  StreamSubscription<Position> _positionStreamSubscription;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MarkerId _selectedMarker;
  final places = GoogleMapsPlaces(apiKey: AppConfig.googleApiKey);
  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager = true;

  @override
  void initState() {
    super.initState();
    _initLocationState();
  }

  Future _initLocationState() async {
    try {
      if (_positionStreamSubscription != null) {
        _positionStreamSubscription.cancel();
      }
      await geolocator.getCurrentPosition();
      const LocationOptions locationOptions = LocationOptions(
          accuracy: LocationAccuracy.bestForNavigation, timeInterval: 1000);
      final Stream<Position> positionStream =
          geolocator.getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen((Position position) {
        setState(() {
          _position = position;
        });
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _position = null;
      });
    }
  }

  @override
  dispose() {
    super.dispose();
    _positionStreamSubscription.cancel();
    _positionStreamSubscription = null;
  }

  Future placesSearch(double latitude, double longitude) async {
    List placesList = List();
    PlacesSearchResponse reponse = await places.searchNearbyWithRadius(
      Location(latitude, longitude),
      20,
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

  _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = _markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (_markers.containsKey(_selectedMarker)) {
          final Marker resetOld = _markers[_selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          _markers[_selectedMarker] = resetOld;
        }
        _selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        _markers[markerId] = newMarker;
      });
    }
  }

  _addMarker(PlacesDetailsResponse place) {
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
      _markers[markerId] = marker;
    });
  }

  _removeMarker() {
    setState(() {
      if (_markers.containsKey(_selectedMarker)) {
        _markers.remove(_selectedMarker);
      }
    });
  }

  _onCameraMove(CameraPosition position) {}

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeolocationStatus>(
        future: geolocator.checkGeolocationPermissionStatus(),
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
                    ? textAppBar('GPS Disabled')
                    : textAppBar('GPS Denied'),
                leading: buttonBackPage(),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  buttonRefresh(),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: textAppBar('Map'),
              leading: buttonBackPage(),
              backgroundColor: Colors.orange[600],
              actions: <Widget>[
                buttonRefresh(),
                buttonMapSearch(),
              ],
            ),
            body: (_position != null)
                ? Stack(
                    children: <Widget>[
                      googleMap(),
                      columnButton(),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          );
        });
  }

  IconButton buttonBackPage() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  IconButton buttonRefresh() {
    return IconButton(
      icon: Icon(Icons.refresh),
      color: Colors.black,
      onPressed: () {
        _initLocationState();
      },
    );
  }

  Text textAppBar(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.black),
    );
  }

  IconButton buttonMapSearch() {
    return IconButton(
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
    );
  }

  GoogleMap googleMap() {
    return GoogleMap(
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        bearing: 270.0,
        target: LatLng(_position.latitude, _position.longitude),
        tilt: 30.0,
        zoom: 15.0,
      ),
      mapType: MapType.normal,
      markers: Set<Marker>.of(_markers.values),
      onCameraMove: _onCameraMove,
    );
  }

  Padding columnButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 70, 12, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: <Widget>[
            SizedBox(width: 38, height: 38, child: buttonRemoveMarker()),
            SizedBox(height: 18.0),
            SizedBox(width: 38, height: 38, child: buttonPlacesSearch()),
          ],
        ),
      ),
    );
  }

  RaisedButton buttonRemoveMarker() {
    return RaisedButton(
      padding: EdgeInsets.all(0.0),
      color: Colors.white,
      onPressed: () {
        _removeMarker();
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      child: Icon(
        Icons.remove,
        size: 10.0,
        color: Colors.black.withOpacity(0.7),
      ),
    );
  }

  RaisedButton buttonPlacesSearch() {
    return RaisedButton(
      padding: const EdgeInsets.all(0.0),
      color: Colors.white,
      onPressed: () {
        placesSearch(_position.latitude, _position.longitude);
      },
      child: Icon(
        Icons.add_location,
        size: 20.0,
        color: Colors.black.withOpacity(0.7),
      ),
    );
  }
}
