import 'package:flutter/material.dart';

import 'package:reit_app/screens/dashboard/dashboard.dart';
import 'package:reit_app/screens/login/login_page.dart';
import 'package:reit_app/screens/profile_page/profile_page.dart';
import 'package:reit_app/screens/splash_page/splash_page.dart';
import 'package:reit_app/screens/location/location_page.dart';
import 'package:reit_app/screens/location/map_search.dart';
import 'package:reit_app/screens/search_reit.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/': (context) => SplashPage(),
    '/Login': (context) => LoginPage(),
    '/Profile': (context) => ProfilePage(),
    '/Dashboard': (context) => Dashboard(),
    '/Search': (context) => SearchReit(),
    '/Location': (context) => LocationPage(),
    '/MapSearch': (context) => MapSearch(),
  };

  Routes() {
    runApp(MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: routes,
    ));
  }
}
