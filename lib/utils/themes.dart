import 'package:flutter/material.dart';

const Color colorGoogleYellow = Color(0xffeff7cf);
const Color colorGoogleGreen = Color(0xff3ddc85);
const Color colorAccentGreen = Color(0xff69f0ae);
const Color colorAGreen400 = Color(0xff00e676);
const Color colorYellow400 = Color(0xfffdf061);
const Color colorOrange400 = Color(0xffe18f3c);
const Color colorModerate = Color(0xff7f9c61);
const Color colorRed400 = Color(0xffff534d);
const Color colorRed900 = Color(0xffb71c1c);

const Color colorWhite = Color(0xffffffff);
const Color colorBlack = Color(0xff000000);

const Color colorDark1 = Color(0xff161616);
const Color colorDark2 = Color(0xff262626);
const Color colorDark3 = Color(0xff363636);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  cardColor: colorWhite,
  buttonColor: colorWhite,
  canvasColor: colorWhite,
  accentColor: colorBlack,
  primaryColor: colorWhite,
  highlightColor: colorGoogleGreen,
  dialogBackgroundColor: colorWhite,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorWhite,
    foregroundColor: colorBlack,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: colorDark2,
  buttonColor: colorDark3,
  canvasColor: colorDark1,
  accentColor: colorWhite,
  primaryColor: colorDark1,
  highlightColor: colorGoogleGreen,
  dialogBackgroundColor: colorDark2,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorDark3,
    foregroundColor: colorWhite,
  ),
);
