import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/utils/constants.dart';
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
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CircleAvatar(
          minRadius: 10,
          backgroundColor: colorTransparent,
          child: SvgPicture.asset(
            imgAppLogo,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
