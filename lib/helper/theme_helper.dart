import 'package:flutter/material.dart';

class ThemeHelper {
  static const primaryColor = Color(0xFFFF6E40);
  static const backgroundColor = Color(0xff1f2029);
  static const white = Colors.white;
  static const green1 = Color(0xff09AA29);
  static const appBarColor = Color.fromARGB(255, 138, 194, 223);

  static const MaterialColor platte1 =
      MaterialColor(_platter1PrimaryValue, <int, Color>{
    50: Color(0xFFFFEEE8),
    100: Color(0xFFFFD4C6),
    200: Color(0xFFFFB7A0),
    300: Color(0xFFFF9A79),
    400: Color(0xFFFF845D),
    500: Color(_platter1PrimaryValue),
    600: Color(0xFFFF663A),
    700: Color(0xFFFF5B32),
    800: Color(0xFFFF512A),
    900: Color(0xFFFF3F1C),
  });
  static const int _platter1PrimaryValue = 0xFFFF6E40;
}
