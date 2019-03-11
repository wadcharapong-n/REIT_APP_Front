import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reit_app/services/search_all_reit_services.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  final int splashDuration = 3;

  startTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      Navigator.of(context).pushReplacementNamed('/Login');
    });
  }

  @override
  void initState() {
    super.initState();
    getReitAll();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black),
                    alignment: FractionalOffset(0.5, 0.3),
                    child: Text(
                      "Reit App",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                  child: Text(
                    "© Copyright Statement 2019",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}
