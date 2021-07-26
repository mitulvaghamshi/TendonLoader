import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';

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
const TextStyle tsG40B = TextStyle(color: colorGoogleGreen, fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle tsR40B = TextStyle(color: colorRed400, fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle tsB40B = TextStyle(color: colorBlack, fontSize: 40, fontWeight: FontWeight.bold);
const TextStyle ts18BFF = TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle ts20BFF = TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle ts22BFF = TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.bold);
const TextStyle tsG18BFF = TextStyle(
  fontSize: 18,
  fontFamily: 'Georgia',
  color: colorGoogleGreen,
  fontWeight: FontWeight.bold,
);
const TextStyle tsG24BFF = TextStyle(
  fontSize: 24,
  fontFamily: 'Georgia',
  color: colorGoogleGreen,
  fontWeight: FontWeight.bold,
);
