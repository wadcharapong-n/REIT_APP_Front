import 'package:flutter/material.dart';
import 'package:reit_app/screens/home_page/widgets/favorite.dart';

@override
Widget appBarDashbord() {
  return AppBar(
    centerTitle: true,
    title: Text(
      'Dashbord',
      style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
          fontSize: 25.0),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {},
      ),
    ],
    backgroundColor: Colors.green[600],
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDashbord(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                     Navigator.pushNamed(context, '/Search');
                },
                child: Container(
                  height: 40.0,
                  width: 700.0,
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.black),
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
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
            child: Text(
              'Favorite',
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.left,
            ),
          ),
          Favorite()
        ],
      ),
    );
  }
}
