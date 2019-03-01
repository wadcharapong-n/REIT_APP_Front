import 'package:flutter/material.dart';
import 'package:reit_app/screens/home_page/widgets/favorite.dart';

@override
Widget appBarDashbord() {
  return AppBar(
    elevation: 0.0,
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
    backgroundColor: Colors.red[200],
  );
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool isEmptyReit = false;

  emptyReit(value) {
    setState(() {
      isEmptyReit = value;
      print(isEmptyReit);
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/Search');
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
          ),
          isEmptyReit == false
              ? Padding(
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
                )
              : Text(''),
          isEmptyReit == false
              ? Container(
                  margin: EdgeInsets.fromLTRB(12, 0, 12, 8),
                  height: 2.5,
                  width: 1000.0,
                  color: Colors.white)
              : Text(''),
          isEmptyReit == false ? Favorite(emptyReit: emptyReit) : Text(''),
        ],
      ),
    );
  }
}
