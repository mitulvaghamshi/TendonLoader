import 'package:flutter/material.dart';

const Color colorGoogleYellow = Color(0xffeff7cf);
const Color colorGoogleGreen = Color(0xff3ddc85);
const Color colorYellow400 = Color(0xfffdf061);
const Color colorOrange400 = Color(0xffe18f3c);
const Color colorRed400 = Color(0xffff534d);
const Color colorWhite = Color(0xffffffff);
const Color colorBlack = Color(0xff000000);
const Color colorLight = Color(0xfffbfbfb);
const Color colorDark = Color(0xff505050);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  buttonColor: colorLight,
  accentColor: colorBlack,
  primaryColor: colorWhite,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorLight,
    foregroundColor: colorBlack,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  buttonColor: colorDark,
  accentColor: colorWhite,
  primaryColor: colorBlack,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorDark,
    foregroundColor: colorWhite,
  ),
);
