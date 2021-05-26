import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:tendon_loader/shared/constants.dart' show Images;

class CustomImage extends StatelessWidget with Images {
  const CustomImage({Key? key, this.name}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    if (name != null) {
      return Image.asset(name!, frameBuilder: (_, Widget child, int? frame, bool wasSync) {
        if (wasSync) return child;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          child: frame != null ? child : const SizedBox(),
        );
      }, excludeFromSemantics: true);
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      padding: const EdgeInsets.all(16),
      child: SvgPicture.asset(
        Images.IMG_APP_LOGO,
        excludeFromSemantics: true,
        color: Theme.of(context).accentColor,
        placeholderBuilder: (_) => const SizedBox(),
      ),
    );
  }
}
