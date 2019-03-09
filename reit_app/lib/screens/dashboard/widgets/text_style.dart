import 'package:flutter/material.dart';

class Style {
  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');

  static final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500);

  static final regularTextStyle = baseTextStyle.copyWith(
      color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400);
  
}
