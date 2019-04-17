import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/services/shared_preferences_service.dart';

class DashboardWidget extends StatefulWidget {
  @override
  DashboardState createState() {
    return DashboardState();
  }
}

class DashboardState extends State<DashboardWidget> {
  bool isEmptyFavoriteReit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: appBarDashbord(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          inputSearch(),
          isEmptyFavoriteReit == false ? headerFavorite() : Text(''),
          isEmptyFavoriteReit == false ? FavoriteReitWidget() : Text(''),
        ],
      ),
    );
  }

  Widget appBarDashbord() {
    return AppBar(
      elevation: 2,
      centerTitle: true,
      title: Text(
        'Dashboard',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0),
      ),
      actions: <Widget>[
        PopupMenuButton(
            itemBuilder: (_) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      child: const Text('Profile'), value: 'Profile'),
                  PopupMenuItem<String>(
                      child: const Text('Logout'), value: 'Logout'),
                ],
            onSelected: (value) {
              if (value == 'Logout') {
                saveLogout().then((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                });
              } else if (value == 'Profile') {
                Navigator.of(context).pushNamed('/Profile');
              }
            }),
      ],
      backgroundColor: Colors.orange[600],
    );
  }

  Column headerFavorite() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 5.0),
          child: Text(
            'Favorite',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
            height: 2.5,
            width: 400.0,
            color: Colors.black),
      ],
    );
  }

  Row inputSearch() {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/Search');
            },
            child: Container(
              height: 40.0,
              width: 310.0,
              margin: const EdgeInsets.fromLTRB(15, 10, 5, 10),
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  Text('Search', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w300,),
                  textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FavoriteReitWidget extends StatefulWidget {
  @override
  FavoriteReitWidgetState createState() => FavoriteReitWidgetState();
}

// #docregion RWS-var
class FavoriteReitWidgetState extends State<FavoriteReitWidget> {
  final favoriteService = Injector.getInjector().get<FavoriteService>();
  List<String> _favoriteReit = new List<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  getFavoriteReitAndSetState() {
    favoriteService.getReitFavoriteByUserId().then((result) {
      setState(() {
        _favoriteReit.clear();
        result.forEach((data) {
          _favoriteReit.add(data.symbol);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getFavoriteReitAndSetState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _buildRow(_favoriteReit[index]);
          },
          itemCount: _favoriteReit.length,
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }

  Widget _buildRow(String reitSymbol) {
    final bool alreadySaved = _favoriteReit.contains(reitSymbol);
    return ListTile(
      title: Text(reitSymbol, style: _biggerFont,),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        if (alreadySaved) {
          favoriteService.deleteReitFavorite(reitSymbol).then((onValue) => {
            getFavoriteReitAndSetState()
          });
          
        } else {
          favoriteService.addReitFavorite(reitSymbol).then((onValue) => {
            getFavoriteReitAndSetState()
          });
        }
      },
    );
  }
}

