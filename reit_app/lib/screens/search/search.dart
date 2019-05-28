import 'package:flutter/material.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/search_service.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Search extends SearchDelegate {
  final searchService = Injector.getInjector().get<SearchService>();

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
    if (query.isEmpty) {
      return FutureBuilder(
          future: searchService.getReitAll(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _SuggestionList(
                query: query,
                suggestions: snapshot.data,
                onSelected: (String symbol) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailReit(
                              reitSymbol: symbol,
                              comeForm: '/Search',
                            )),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    } else {
      return FutureBuilder(
          future: searchService.reitSearch(query),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _SuggestionList(
                query: query,
                suggestions: snapshot.data,
                onSelected: (String symbol) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailReit(
                              reitSymbol: symbol,
                            )),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    }
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

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return FutureBuilder(
          future: searchService.getReitAll(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _SuggestionList(
                query: query,
                suggestions: snapshot.data,
                onSelected: (String symbol) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailReit(
                              reitSymbol: symbol,
                            )),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    } else {
      return FutureBuilder(
          future: searchService.reitSearch(query),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _SuggestionList(
                query: query,
                suggestions: snapshot.data,
                onSelected: (String symbol) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailReit(
                              reitSymbol: symbol,
                            )),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    }
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<dynamic> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Dashboard', (Route<dynamic> route) => false);
        return Future.value(false);
      },
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 0),
            title: Text(suggestions[index].symbol),
            subtitle: Text(suggestions[index].trustNameTh),
            onTap: () {
              onSelected(suggestions[index].symbol);
            },
          );
        },
      ),
    );
  }
}
