/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';

const Color colorTransparent = Color(0x00000000);

const Color colorLightYellow = Color(0xffeff7cf);
const Color colorMidYellow = Color(0xfffdf061);

const Color colorAccentGreen = Color(0xff69f0ae);
const Color colorMidGreen = Color(0xff3ddc85);
const Color colorDarkGreen = Color(0xff00e676);

const Color colorPrimaryWhite = Color(0xffffffff);
const Color colorAccentBlack = Color(0xff000000);
const Color colorIconBlue = Color(0xff2196f3);

const Color colorPrimaryDark = Color(0xff141414);
const Color colorBackgroundDark = Color(0xff262626);
const Color colorButtonDark = Color(0xff404040);

const Color colorModerate = Color(0xff7f9c61);
const Color colorMidOrange = Color(0xffe18f3c);
const Color colorErrorRed = Color(0xffff534d);
const Color colorDarkRed = Color(0xffb71c1c);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  cardColor: colorPrimaryWhite,
  buttonColor: colorPrimaryWhite,
  canvasColor: colorPrimaryWhite,
  accentColor: colorAccentBlack,
  primaryColor: colorPrimaryWhite,
  highlightColor: colorMidGreen,
  dialogBackgroundColor: colorPrimaryWhite,
  iconTheme: const IconThemeData(color: colorMidGreen),
  dividerTheme: const DividerThemeData(color: colorPrimaryDark),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorPrimaryWhite,
    foregroundColor: colorAccentBlack,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: colorAccentBlack),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorErrorRed),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorIconBlue),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorMidGreen),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: colorBackgroundDark,
  buttonColor: colorButtonDark,
  canvasColor: colorPrimaryDark,
  accentColor: colorPrimaryWhite,
  primaryColor: colorPrimaryDark,
  highlightColor: colorMidGreen,
  dialogBackgroundColor: colorBackgroundDark,
  iconTheme: const IconThemeData(color: colorMidGreen),
  dividerTheme: const DividerThemeData(color: colorPrimaryWhite),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorButtonDark,
    foregroundColor: colorPrimaryWhite,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: colorPrimaryWhite),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorErrorRed),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorIconBlue),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorMidGreen),
    ),
  ),
);

const TextStyle tsW = TextStyle(color: colorPrimaryWhite);

const TextStyle tsBW500 =
    TextStyle(color: colorAccentBlack, fontWeight: FontWeight.w500);

const TextStyle ts18w5 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
const TextStyle ts22B = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

const TextStyle tsG18B =
    TextStyle(color: colorMidGreen, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle tsG20B =
    TextStyle(color: colorMidGreen, fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle tsG24B =
    TextStyle(color: colorMidGreen, fontSize: 24, fontWeight: FontWeight.bold);
const TextStyle tsG40B =
    TextStyle(color: colorMidGreen, fontSize: 40, fontWeight: FontWeight.bold);

const TextStyle tsR20B =
    TextStyle(color: colorErrorRed, fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle tsR40B =
    TextStyle(color: colorErrorRed, fontSize: 40, fontWeight: FontWeight.bold);

const TextStyle tsW24B = TextStyle(
    color: colorPrimaryWhite, fontSize: 24, fontWeight: FontWeight.bold);

const TextStyle tsB40B = TextStyle(
    color: colorAccentBlack, fontSize: 40, fontWeight: FontWeight.bold);

/// Create a text style with bold face, custom green color and a size of 40fp.
///
/// ```dart
/// Text('40 sized green text'
///   TextStyle(
///     fontSize: 40,
///     color: colorGoogleGreen,
///     fontWeight: FontWeight.bold,
///   ),
/// );
/// ```
/// The colorGoogleGreen is:
/// ```dart
/// Color(0xff3ddc85);
/// ```
