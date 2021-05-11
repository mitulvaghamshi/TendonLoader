import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TextStyle get tsBold26 => const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);

Future<void> goto(String url) async {
  if (await canLaunch(url)) {
    await launch(url, webOnlyWindowName: 'Tendon Loader', statusBarBrightness: Brightness.light);
  }
}
