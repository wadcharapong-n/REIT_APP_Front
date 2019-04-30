import 'dart:async';
import 'package:flutter/material.dart';

class SplashService {
  startTime(String token, int splashDuration, BuildContext context) async {
    return Timer(Duration(seconds: splashDuration), () {
      if (token != null) {
        Navigator.of(context).pushReplacementNamed('/Dashboard');
      } else {
        Navigator.of(context).pushReplacementNamed('/Login');
      }
    });
  }
}
