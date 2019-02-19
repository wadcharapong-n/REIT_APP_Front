import 'package:flutter/material.dart';
import 'package:reit_app/screens/home_page/home_page.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    // '/': (context) => FirstScreen(),
    '/Home': (context) => HomePage()
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'Flutter Demo',
      // initialRoute: '/',
      routes: routes,
      home: HomePage(),
    ));
  }
}
