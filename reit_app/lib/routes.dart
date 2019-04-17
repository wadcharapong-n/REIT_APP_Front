import 'package:flutter/material.dart';
import 'package:reit_app/dashboard_widget.dart';

import 'package:reit_app/screens/dashboard/dashboard.dart';
import 'package:reit_app/screens/login/login.dart';
import 'package:reit_app/screens/profile/profile.dart';
import 'package:reit_app/screens/splash/splash.dart';
import 'package:reit_app/screens/location/location_page.dart';
import 'package:reit_app/screens/location/map_search.dart';
import 'package:reit_app/screens/search/search.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/': (context) => SplashPage(),
    '/Login': (context) => LoginPage(),
    '/Profile': (context) => ProfilePage(),
    '/Dashboard': (context) => Dashboard(),
    // '/Dashboard': (context) => DashboardWidget(),
    '/Search': (context) => SearchPage(),
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
