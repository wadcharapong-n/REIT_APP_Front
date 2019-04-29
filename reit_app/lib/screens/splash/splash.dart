import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/services/splash_service.dart';
import 'package:reit_app/services/shared_preferences_service.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  final sharedPreferencesService = Injector.getInjector().get<SharedPreferencesService>();
  final int splashDuration = 2;

  @override
  void initState() {
    super.initState();
    sharedPreferencesService.getToken().then((resultToken) {
      startTime(resultToken, splashDuration, context);
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
