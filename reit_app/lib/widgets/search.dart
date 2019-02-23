import 'package:flutter/material.dart';
import 'package:reit_app/services/search_all_reit_services.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List suggestion = List();

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          suggestion = dataAllReit;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          suggestion = dataAllReit;
        });
      }
    });
  }

  @override
  void initState() {
    this._getData();
    super.initState();
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
          suggestion = dataAllReit;
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
                  suggestion = dataAllReit;
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
        itemCount: dataAllReit == null ? 0 : suggestion.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(8, 5, 0, 0),
            child: ListTile(
              title: Text(suggestion[index].symbol),
              subtitle: Text(suggestion[index].name),
              onTap: () {
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageRoute()),
                  );
                }
              },
            ),
          );
        },
      );
  }

  void _getData() async {
    print('Success');
    setState(() {
      dataAllReit.shuffle();
      suggestion = dataAllReit;
    });
  }
}

class PageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
