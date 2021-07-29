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
const Color colorBlue = Color(0xff2196f3);

const Color colorDark1 = Color(0xff141414);
const Color colorDark2 = Color(0xff262626);
const Color colorDark3 = Color(0xff363636);

const Color colorTransparent = Color(0x00000000);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  cardColor: colorWhite,
  buttonColor: colorWhite,
  canvasColor: colorWhite,
  accentColor: colorBlack,
  primaryColor: colorWhite,
  highlightColor: colorGoogleGreen,
  dialogBackgroundColor: colorWhite,  
  dividerTheme: const DividerThemeData(color: colorDark1),
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
  dividerTheme: const DividerThemeData(color: colorWhite),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorDark3,
    foregroundColor: colorWhite,
  ),
);

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
const TextStyle tsR40B = TextStyle(color: colorRed400, fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle tsB40B = TextStyle(color: colorBlack, fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle tsG40B = TextStyle(color: colorGoogleGreen, fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle ts18BFF = TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle ts20BFF = TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle ts22BFF = TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.bold);
const TextStyle tsW24B900FF =
    TextStyle(fontSize: 24, color: colorWhite, fontFamily: 'Georgia', fontWeight: FontWeight.w900);
const TextStyle tsG18BFF =
    TextStyle(fontSize: 18, fontFamily: 'Georgia', color: colorGoogleGreen, fontWeight: FontWeight.bold);
const TextStyle tsG24BFF =
    TextStyle(fontSize: 24, fontFamily: 'Georgia', color: colorGoogleGreen, fontWeight: FontWeight.bold);

const TextStyle tsR18B =
    TextStyle(fontFamily: 'Georgia', color: colorRed400, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle tsG18B =
    TextStyle(fontFamily: 'Georgia', color: colorGoogleGreen, fontSize: 18, fontWeight: FontWeight.bold);
