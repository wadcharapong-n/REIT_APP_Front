import 'dart:async';

import 'package:flutter/material.dart';
import "package:google_maps_webservice/places.dart";

class MapSearch extends StatefulWidget {
  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List _suggestion = List();
  final places =
      new GoogleMapsPlaces(apiKey: "AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y");

  @override
  void initState() {
    super.initState();

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: _buildList(),
      ),
      // resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: TextField(
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontFamily: 'Poppins'),
        autofocus: true,
        controller: _filter,
        textInputAction: TextInputAction.search,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          _filter.clear();
          _suggestion.clear();
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        !(_filter.text.isEmpty)
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  _filter.clear();
                  _suggestion.clear();
                },
              )
            : Text('')
      ],
    );
  }

  Future<List> placesSearch(String searchText) async {
    List placesList = List();
    List placesDetail = List();
    PlacesAutocompleteResponse reponse =
        await places.autocomplete(searchText, language: 'th');
    if (reponse.isOkay) {
      reponse.predictions.forEach((Prediction place) {
        placesList.add(place);
      });
    }

    for (var place in placesList) {
      PlacesDetailsResponse details =
          await places.getDetailsByPlaceId(place.placeId, language: 'th');
      placesDetail.add(details);
    }
    return placesDetail;
  }

  Widget _buildList() {
    return FutureBuilder(
        future: placesSearch(_searchText),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _suggestion = snapshot.data;
            return ListView.builder(
              itemCount: _suggestion.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(8, 5, 0, 0),
                  child: ListTile(
                    title: Text(_suggestion[index].result.name),
                    subtitle: Text(_suggestion[index].result.formattedAddress),
                    onTap: () {
                      Navigator.pop(context,_suggestion[index]);
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
