import 'package:flutter/material.dart';
import 'package:reit_app/screens/home_page/home_page.dart';
import 'package:reit_app/widgets/search.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    // '/': (context) => FirstScreen(),
    '/Home': (context) => HomePage(),
    '/Search': (context) => ExamplePage()
  };

  Routes() {
    runApp(MaterialApp(
      title: 'Flutter Demo',
      // initialRoute: '/',
      routes: routes,
      home: HomePage(),
    ));
  }
}
