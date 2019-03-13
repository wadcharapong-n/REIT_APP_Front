import 'package:flutter/material.dart';
import 'package:reit_app/screens/dashboard/widgets/favorite.dart';
import 'package:reit_app/functions/save_logout.dart';
import 'package:reit_app/screens/profile_page/profile_page.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  bool isEmptyReit = false;

  checkIsEmptyReit(value) {
    setState(() {
      isEmptyReit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: appBarDashbord(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          inputSearch(),
          isEmptyReit == false ? headerFavorite() : Text(''),
          isEmptyReit == false
              ? Favorite(checkIsEmptyReit: checkIsEmptyReit)
              : Text(''),
        ],
      ),
    );
  }

  Widget appBarDashbord() {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        'Dashbord',
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 25.0),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.of(context).pushNamed('/Profile');
          },
        ),
        IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () {
            saveLogout().then((v) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Login', (Route<dynamic> route) => false);
            });
          },
        ),
      ],
      backgroundColor: Colors.red[200],
    );
  }

  Container inputSearch() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/Search').then((result) {
            setState(() {
              if (FavoriteState.reitsFavorite.length == 0) {
                isEmptyReit = true;
              } else {
                isEmptyReit = false;
              }
            });
          });
        },
        child: Container(
          height: 40.0,
          width: 1000.0,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              Text(
                '  Search',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column headerFavorite() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
          child: Text(
            'Favorite',
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(12, 0, 12, 8),
            height: 2.5,
            width: 1000.0,
            color: Colors.white),
      ],
    );
  }
}
