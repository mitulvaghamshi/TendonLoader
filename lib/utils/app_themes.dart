import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  canvasColor: Colors.white,
  splashColor: Colors.black,
  accentColor: Colors.black,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    splashColor: Colors.black,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData darkTheme = ThemeData(
  splashColor: Colors.white,
  accentColor: Colors.white,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(Colors.white),
    checkColor: MaterialStateProperty.all<Color>(Colors.black),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    splashColor: Colors.white,
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,
  ),
);
