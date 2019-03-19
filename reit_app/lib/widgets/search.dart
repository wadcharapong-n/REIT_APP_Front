import 'package:flutter/material.dart';
import 'package:reit_app/services/search_all_reit_services.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/models/reit.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = TextEditingController();
  List<Reit> reitAll = List();
  String _searchText = "";
  List suggestion = List();

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          suggestion = reitAll;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          suggestion = reitAll;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getReitAll().then((result) {
      reitAll = result;
      this._getReitAll();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
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
          suggestion = reitAll;
          _filter.clear();
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
                  suggestion = reitAll;
                  _filter.clear();
                },
              )
            : Text('')
      ],
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = List();
      for (int i = 0; i < suggestion.length; i++) {
        if (suggestion[i]
            .symbol
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(suggestion[i]);
        }
      }
      suggestion = tempList;
    }
    return ListView.builder(
      itemCount: reitAll == null ? 0 : suggestion.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.fromLTRB(8, 5, 0, 0),
          child: ListTile(
            title: Text(suggestion[index].symbol),
            subtitle: Text(suggestion[index].trustNameTh),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailReit(
                          reitSymbol: suggestion[index].symbol,
                        )),
              );
            },
          ),
        );
      },
    );
  }

  void _getReitAll() async {
    setState(() {
      reitAll.shuffle();
      suggestion = reitAll;
    });
  }
}
