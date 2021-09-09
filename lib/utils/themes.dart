/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

/// The app is designed with using two basic themes of Light and Dark.
import 'package:flutter/material.dart';

/// Below are 16 different colors used by the app
/// and by both the themes, for coloring text, 
/// buttons and backgrounds. 

/// transparent color - defined for reusability.
const Color colorTransparent = Color(0x00000000);

/// Two custom shades of light yellow and slight dark yellow.
const Color colorLightYellow = Color(0xffeff7cf);
const Color colorMidYellow = Color(0xfffdf061);

/// Green shades with very little difference in between.
const Color colorAccentGreen = Color(0xff69f0ae);
const Color colorMidGreen = Color(0xff3ddc85);
const Color colorDarkGreen = Color(0xff00e676);

/// A full white, black and a blue color (used for icons).
const Color colorPrimaryWhite = Color(0xffffffff);
const Color colorAccentBlack = Color(0xff000000);
const Color colorIconBlue = Color(0xff2196f3);

/// Dark shades mostly used by the dark theme to
/// distinguish between background, card and buttons laid in it. 
const Color colorPrimaryDark = Color(0xff141414);
const Color colorBackgroundDark = Color(0xff262626);
const Color colorButtonDark = Color(0xff404040);

/// Red and orange used by errors and to display 
/// different level of pain score.
const Color colorModerate = Color(0xff7f9c61);
const Color colorMidOrange = Color(0xffe18f3c);
const Color colorErrorRed = Color(0xffff534d);
const Color colorDarkRed = Color(0xffb71c1c);

/// Light Theme data,
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

/// Dark Theme data.
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

/// Below are the different colored and sized text style used,
/// to prioretize texts with different look on same the screen.

/// Just white colored text with device default size and style.
/// shared by both the themes for identical look.
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

/// A template to document a textstyle(here) or any component
/// with code preview on hover in IDEs. 

/// Create a text style with bold face, custom green color and a size of 40fp.
/// ```dart
/// Text('40 sized green text'
///   TextStyle(
///     fontSize: 40,
///     color: Colors.green,
///     fontWeight: FontWeight.bold,
///   ),
/// );
/// ```
