import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key, required this.value}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 2, color: value > 0 ? colorGoogleGreen : colorRed400);
  }
}
