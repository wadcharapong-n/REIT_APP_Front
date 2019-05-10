import 'package:flutter/material.dart';
import 'package:reit_app/services/map_search_service.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import "package:google_maps_webservice/places.dart";

class MapSearch extends SearchDelegate {
  final mapSearchService = Injector.getInjector().get<MapSearchService>();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: mapSearchService.placesSearch(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _SuggestionList(
              query: query,
              suggestions: snapshot.data,
              onSelected: (PlacesDetailsResponse suggestion) {
                Navigator.pop(context, suggestion);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: mapSearchService.textSearch(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.results.length != 0) {
              print(snapshot.data.results.length);
              return ListView.builder(
                itemCount: snapshot.data.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                    title: Text(snapshot.data.results[index].name),
                    subtitle:
                        Text(snapshot.data.results[index].formattedAddress),
                    onTap: () {
                      Navigator.pop(context, snapshot.data.results[index]);
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Maps not found \n"$query"\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Prompt',
                  ),
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Text('')
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<dynamic> suggestions;
  final String query;
  final ValueChanged<PlacesDetailsResponse> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 0),
          title: Text(suggestions[index].result.name),
          subtitle: Text(suggestions[index].result.formattedAddress),
          onTap: () {
            onSelected(suggestions[index]);
          },
        );
      },
    );
  }
}
