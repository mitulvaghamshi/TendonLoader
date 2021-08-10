import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/utils/images.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({Key? key, this.name}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    if (name != null) {
      return Image.asset(name!, frameBuilder: (_, Widget child, int? frame, ___) {
        return AnimatedOpacity(duration: const Duration(seconds: 1), opacity: frame == null ? 0 : 1, child: child);
      }, fit: BoxFit.contain);
    }
    return FittedBox(
        child: CircleAvatar(
      minRadius: 100,
      backgroundColor: colorTransparent,
      child: SvgPicture.asset(imgAppLogo, color: Theme.of(context).accentColor),
    ));
  }
}
