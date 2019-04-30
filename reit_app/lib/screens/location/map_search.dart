import 'package:flutter/material.dart';
import 'package:reit_app/app_config.dart';
import 'package:reit_app/services/map_search_service.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import "package:google_maps_webservice/places.dart";

class MapSearch extends StatefulWidget {
  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final mapSearchService = Injector.getInjector().get<MapSearchService>();

  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List _suggestion = List();
  final places = GoogleMapsPlaces(apiKey: AppConfig.googleApiKey);

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
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: textFieldSearch(),
      leading: buttonBackPage(),
      actions: <Widget>[
        !(_filter.text.isEmpty) ? buttonClearFilter() : Text('')
      ],
    );
  }

  TextField textFieldSearch() {
    return TextField(
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
      autofocus: true,
      controller: _filter,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(border: InputBorder.none, hintText: 'Search'),
    );
  }

  IconButton buttonBackPage() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        _filter.clear();
        _suggestion.clear();
        Navigator.pop(context);
      },
    );
  }

  IconButton buttonClearFilter() {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.black,
      ),
      onPressed: () {
        _filter.clear();
        _suggestion.clear();
      },
    );
  }

  Widget _buildList() {
    return FutureBuilder(
        future: mapSearchService.placesSearch(_searchText),
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
                      Navigator.pop(context, _suggestion[index]);
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
