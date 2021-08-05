import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({Key? key, this.text = 'Please wait...'}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
      leading: const CircularProgressIndicator(color: colorGoogleGreen),
      title: Text(text, style: const TextStyle(fontSize: 20, fontFamily: 'Georgia')),
    );
  }
}
