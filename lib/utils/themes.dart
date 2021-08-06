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
const Color colorDark3 = Color(0xff404040);

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
  iconTheme: const IconThemeData(color: colorGoogleGreen),
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
  iconTheme: const IconThemeData(color: colorGoogleGreen),
  dividerTheme: const DividerThemeData(color: colorWhite),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorDark3,
    foregroundColor: colorWhite,
  ),
);

const TextStyle ts18B = TextStyle(fontSize: 18, fontWeight: FontWeight.w900);
const TextStyle ts20B = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
const TextStyle ts22B = TextStyle(fontSize: 22, fontWeight: FontWeight.w900);

const TextStyle tsG18B = TextStyle(color: colorGoogleGreen, fontSize: 18, fontWeight: FontWeight.w900);
const TextStyle tsG20B = TextStyle(color: colorGoogleGreen, fontSize: 20, fontWeight: FontWeight.w900);
const TextStyle tsG24B = TextStyle(color: colorGoogleGreen, fontSize: 24, fontWeight: FontWeight.w900);
const TextStyle tsG40B = TextStyle(color: colorGoogleGreen, fontSize: 40, fontWeight: FontWeight.w900);

const TextStyle tsR20B = TextStyle(color: colorRed400, fontSize: 20, fontWeight: FontWeight.w900);
const TextStyle tsR40B = TextStyle(color: colorRed400, fontSize: 40, fontWeight: FontWeight.w900);

const TextStyle tsW24B = TextStyle(color: colorWhite, fontSize: 24, fontWeight: FontWeight.w900);

const TextStyle tsB40B = TextStyle(color: colorBlack, fontSize: 40, fontWeight: FontWeight.w900);

/// Create a text style with w900 face, custom green color and a size of 40fp.
///
/// ```dart
/// Text('40 sized green text'
///   TextStyle(
///     fontSize: 40,
///     color: colorGoogleGreen,
///     fontWeight: FontWeight.w900,
///   ),
/// );
/// ```
/// The colorGoogleGreen is:
/// ```dart
/// Color(0xff3ddc85);
/// ```
