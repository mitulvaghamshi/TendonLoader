import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_tile.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({Key? key, this.text = 'Please wait...'}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomTile(title: text, left: const CircularProgressIndicator.adaptive());
  }
}
