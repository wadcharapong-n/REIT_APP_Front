import 'package:flutter/material.dart';
import 'package:reit_app/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REIT APP',
      home: HomePage(),
    );
  }
}
