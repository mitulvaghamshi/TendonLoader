import 'package:flutter/material.dart';

const Color googleYellow = Color(0xffeff7cf);
const Color googleGreen = Color(0xff3ddc85);
const Color yellow400 = Color(0xfffdf061);
const Color orange400 = Color(0xffe18f3c);
const Color red400 = Color(0xffff534d);
const Color white = Color(0xffffffff);
const Color black = Color(0xff000000);
const Color light = Color(0xfffbfbfb);
const Color dark = Color(0xff505050);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  buttonColor: light,
  accentColor: black,
  primaryColor: white,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: light,
    foregroundColor: black,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  buttonColor: dark,
  accentColor: white,
  primaryColor: black,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: dark,
    foregroundColor: white,
  ),
);
