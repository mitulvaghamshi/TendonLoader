import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(  
  splashColor: Colors.deepOrange,
  accentColor: Colors.black,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

final ThemeData darkTheme = ThemeData(
  splashColor: Colors.deepOrange,
  accentColor: Colors.white,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);
