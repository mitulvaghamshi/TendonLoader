import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/shared/utils/constants.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, this.name});

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
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CircleAvatar(
          minRadius: 10,
          backgroundColor: const Color(0x00000000),
          child: SvgPicture.asset(imgAppLogo),
        ),
      ),
    );
  }
}
