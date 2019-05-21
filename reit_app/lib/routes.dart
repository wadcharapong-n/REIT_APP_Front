import 'package:flutter/material.dart';
import 'package:reit_app/screens/dashboard/dashboard.dart';
import 'package:reit_app/screens/login/login.dart';
import 'package:reit_app/screens/profile/profile.dart';
import 'package:reit_app/screens/splash/splash.dart';
import 'package:reit_app/screens/location/location_page.dart';
import 'package:reit_app/screens/reit_all.dart/reit_all.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/': (context) => Splash(),
    '/Login': (context) => Login(),
    '/Profile': (context) => Profile(),
    '/Dashboard': (context) => Dashboard(),
    '/Location': (context) => LocationPage(),
    '/ReitAll': (context) => ReitAll(),
  };

  Routes() {
    runApp(MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: routes,
      debugShowCheckedModeBanner: false,
      
    ));
  }
}
