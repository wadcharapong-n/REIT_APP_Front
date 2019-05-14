import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/models/place.dart';
import 'package:reit_app/loader.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/screens/location/map_search.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/location_page_service.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/places.dart" as googleService;

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final locationPageService = Injector.getInjector().get<LocationPageService>();
  final authenService = Injector.getInjector().get<AuthenService>();

  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = new Location();
  bool _permission = false;
  String error;

  GoogleMapController mapController;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MarkerId _selectedMarker;
  MarkerId _isMarker;

  final places = googleService.GoogleMapsPlaces(apiKey: AppConfig.googleApiKey);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    LocationData location;

    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        if (_permission) {
          location = await _locationService.getLocation();
          await _locationService.changeSettings(
              accuracy: LocationAccuracy.HIGH, interval: 1000);
          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  @override
  dispose() {
    super.dispose();
    _locationSubscription.cancel();
  }

  _onCameraMove(CameraPosition position) {}

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _addMarkerTap(LatLng point) {
    final String markerIdVal = point.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: point,
      infoWindow: InfoWindow(
          title: 'Marker Tap',
          snippet: 'Find Reit Around',
          onTap: () {
            locationPageService
                .getSearchAroundReit(
                    point.latitude.toString(), point.longitude.toString())
                .then((result) {
              _showModalSheet(result);
            }).catchError(
                    (_) => {authenService.LogoutAndNavigateToLogin(context)});
          }),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      _markers.clear();
      _isMarker = MarkerId(markerIdVal);
      _markers[markerId] = marker;
    });
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
        _locationSubscription.cancel();
        initPlatformState();
      },
    );
  }

  Text showTextAppBar(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          fontFamily: 'Prompt'),
    );
  }

  IconButton buttonMapSearch() {
    return IconButton(
      icon: Icon(Icons.search),
      color: Colors.black,
      onPressed: () async {
        await showSearch(
          context: context,
          delegate: MapSearch(),
        ).then((result) {
          if (result is googleService.PlacesDetailsResponse) {
            googleService.PlacesDetailsResponse place = result;
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
            _addMarkerTap(LatLng(place.result.geometry.location.lat,
                place.result.geometry.location.lng));
          } else if (result is googleService.PlacesSearchResult) {
            googleService.PlacesSearchResult place = result;
            mapController.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 270.0,
                  target: LatLng(
                      place.geometry.location.lat, place.geometry.location.lng),
                  tilt: 30.0,
                  zoom: 17.0,
                ),
              ),
            );
            _addMarkerTap(LatLng(
                place.geometry.location.lat, place.geometry.location.lng));
          }
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
        target: (_startLocation != null)
            ? LatLng(_startLocation.latitude, _startLocation.longitude)
            : LatLng(0, 0),
        tilt: 30.0,
        zoom: (_startLocation != null) ? 15.0 : 5,
      ),
      mapType: MapType.normal,
      markers: Set<Marker>.of(_markers.values),
      onCameraMove: _onCameraMove,
      onTap: _addMarkerTap,
    );
  }

  Container columnButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 60, 12, 0),
      child: Align(
          alignment: Alignment.topRight,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(width: 120, child: buttonFindReitLocation()),
                (_markers[_isMarker] != null)
                    ? SizedBox(width: 120, child: buttonFindReitMarker())
                    : SizedBox(),
              ],
            ),
          )),
    );
  }

  RaisedButton buttonFindReitLocation() {
    return RaisedButton(
        padding: EdgeInsets.all(4),
        color: Colors.white.withOpacity(0.9),
        onPressed: () {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 270.0,
                target: LatLng(
                    _currentLocation.latitude, _currentLocation.longitude),
                tilt: 30.0,
                zoom: 15.0,
              ),
            ),
          );
          locationPageService
              .getSearchAroundReit(_currentLocation.latitude.toString(),
                  _currentLocation.longitude.toString())
              .then((result) {
            _showModalSheet(result);
          }).catchError(
                  (_) => {authenService.LogoutAndNavigateToLogin(context)});
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        child: Text('Find Reit Current Location'));
  }

  RaisedButton buttonFindReitMarker() {
    return RaisedButton(
        padding: const EdgeInsets.all(4.0),
        color: Colors.white.withOpacity(0.9),
        onPressed: () {
          if (_markers[_isMarker] != null) {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 270.0,
                  target: LatLng(_markers[_isMarker].position.latitude,
                      _markers[_isMarker].position.longitude),
                  tilt: 30.0,
                  zoom: 15.0,
                ),
              ),
            );
            locationPageService
                .getSearchAroundReit(
                    _markers[_isMarker].position.latitude.toString(),
                    _markers[_isMarker].position.longitude.toString())
                .then((result) {
              _onMarkerTapped(_isMarker);
              _showModalSheet(result);
            }).catchError(
                    (_) => {authenService.LogoutAndNavigateToLogin(context)});
          }
        },
        child: Text('Find Reit Around Marker'));
  }

  _showModalSheet(Place place) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          if (place.reit != null) {
            return Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.40,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Text(place.symbol,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Prompt',
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: ButtonTheme(
                            padding: const EdgeInsets.all(4),
                            minWidth: 50.0,
                            height: 25.0,
                            child: RaisedButton(
                              child: Text(
                                'View Information',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Prompt',
                                ),
                              ),
                              color: Colors.green,
                              elevation: 4.0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailReit(
                                            reitSymbol: place.reit[0].symbol,
                                          )),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    )),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "ชื่อสินทรัพย์",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            place.name,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            "ชื่อ Reit",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            "TH : " + place.reit[0].trustNameTh,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            "EN : " + place.reit[0].trustNameEn,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            "ที่อยู่",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            place.address,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "LAT/LONG : " +
                              place.location.latitude.toString() +
                              " " +
                              place.location.longitude.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container(
              height: 100,
              margin: EdgeInsets.all(15),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Not Found Reit",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Prompt',
                          )),
                    ],
                  )),
                ],
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
        future: Future.wait([
          _locationService.hasPermission(),
          _locationService.serviceEnabled(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Loader(),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data[0] == false || snapshot.data[1] == false) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: (snapshot.data[0] == false)
                      ? showTextAppBar('GPS Disabled')
                      : showTextAppBar('GPS Denied'),
                  leading: buttonBackPage(),
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    buttonRefresh(),
                  ],
                ),
                body: Center(
                  child: RaisedButton(
                    child: const Text(
                      "Connect GPS",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'Prompt'),
                    ),
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      _locationSubscription.cancel();
                      initPlatformState();
                    },
                  ),
                ),
              );
            }
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: showTextAppBar('Map'),
              leading: buttonBackPage(),
              backgroundColor: Colors.orange[600],
              actions: <Widget>[
                buttonRefresh(),
                buttonMapSearch(),
              ],
            ),
            body: (_currentLocation != null)
                ? Stack(
                    children: <Widget>[
                      googleMap(),
                      columnButton(),
                    ],
                  )
                : Center(
                    child: Loader(),
                  ),
          );
        });
  }
}
