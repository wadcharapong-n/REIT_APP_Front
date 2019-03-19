import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reit_app/functions/get_token.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  final int splashDuration = 2;

  @override
  void initState() {
    super.initState();
    getToken().then((resultToken) {
      startTime(resultToken);
    });
  }

  startTime(String token) async {
    return Timer(Duration(seconds: splashDuration), () {
      if (token != null) {
        Navigator.of(context).pushReplacementNamed('/Dashboard');
      } else {
        Navigator.of(context).pushReplacementNamed('/Login');
      }
    });
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
        ),
      ),
    );
  }
}
