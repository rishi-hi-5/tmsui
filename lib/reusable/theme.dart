import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.blueAccent;
  static const Color secondaryColor = Colors.white;
  static const Color primaryTextColor = Colors.white;
  static const Color secondaryTextColor = Colors.black;
  static const Color inputFieldColor = Colors.white;
  static const Color borderColor = Colors.black;
  static const Color cardColor = Colors.white;
  static const Color dialogColor = Colors.white;
  static const Color dangerColor = Colors.red;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryColor,
    appBarTheme: const AppBarTheme(
      color: secondaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 20, color: primaryTextColor),
      titleLarge: TextStyle(fontSize: 35, color: primaryColor),
    ),
  );
}
