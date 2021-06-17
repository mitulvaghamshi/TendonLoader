import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  splashColor: Colors.black,
  accentColor: Colors.black,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    splashColor: Colors.black,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

final ThemeData darkTheme = ThemeData(
  splashColor: Colors.white,
  accentColor: Colors.white,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    splashColor: Colors.white,
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);
