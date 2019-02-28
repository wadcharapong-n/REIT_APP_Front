import 'package:flutter/material.dart';
import 'package:reit_app/screens/home_page/home_page.dart';
import 'package:reit_app/widgets/search.dart';
import 'package:reit_app/screens/profile_page/profile_page.dart';
import 'package:reit_app/screens/login/login_page.dart';


class Routes {
  final routes = <String, WidgetBuilder>{
     '/': (context) => LoginPage(),
    ProfilePage.tag : (context) => ProfilePage(),
    '/Home': (context) => HomePage(),
    '/Search': (context) => ExamplePage()
  };

  Routes() {
    runApp(MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: routes,
    ));
  }
}
