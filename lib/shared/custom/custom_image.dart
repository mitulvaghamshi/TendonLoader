import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:tendon_loader/shared/constants.dart' show Images;

class CustomImage extends StatelessWidget with Images {
  const CustomImage({Key key, this.name, this.radius = 120, this.isLogo = false}) : super(key: key);

  final bool isLogo;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (name != null) return Image.asset(name);

    final Color _accent = Theme.of(context).accentColor;
    final Color _primary = Theme.of(context).primaryColor;
    final SvgPicture _image = SvgPicture.asset(Images.IMG_APP_LOGO, color: _accent);

    return Container(
      color: isLogo ? null : _primary,
      padding: const EdgeInsets.all(30),
      child: isLogo ? CircleAvatar(child: _image, radius: radius, backgroundColor: _primary) : _image,
    );
  }
}
