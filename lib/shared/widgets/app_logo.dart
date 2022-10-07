import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/shared/utils/constants.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
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
