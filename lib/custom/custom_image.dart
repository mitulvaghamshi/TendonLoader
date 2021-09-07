/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({Key? key, this.name}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    if (name != null) {
      return Image.asset(
        name!,
        fit: BoxFit.contain,
        frameBuilder: (_, Widget child, int? frame, ___) => AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: frame == null ? 0 : 1,
          child: child,
        ),
      );
    }
    return const FittedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: CircleAvatar(
          backgroundColor: colorTransparent,
          minRadius: 10,
          child: AppLogo(),
        ),
      ),
    );
  }
}
