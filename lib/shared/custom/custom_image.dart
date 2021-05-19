import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:tendon_loader/shared/constants.dart' show Images;

class CustomImage extends StatelessWidget with Images {
  const CustomImage({
    Key key,
    this.name,
    this.padding = 30,
    this.radius = 120,
    this.isBg = false,
    this.isLogo = false,
  }) : super(key: key);

  final bool isBg;
  final bool isLogo;
  final String name;
  final double radius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    if (name != null) {
      return Image.asset(
        name,
        frameBuilder: (_, Widget child, int frame, bool wasSync) {
          if (wasSync) {
            return child;
          } else {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: frame != null ? child : const SizedBox(),
            );
          }
        },
      );
    }

    final Color _accent = Theme.of(context).accentColor;
    final Color _primary = Theme.of(context).primaryColor;
    final SvgPicture _image = SvgPicture.asset(
      Images.IMG_APP_LOGO,
      color: _accent,
      placeholderBuilder: (_) => const SizedBox(),
    );

    if (isBg) return _image;

    return Container(
      color: isLogo ? null : _primary,
      padding: EdgeInsets.all(padding),
      child: isLogo ? CircleAvatar(child: _image, radius: radius, backgroundColor: _primary) : _image,
    );
  }
}
