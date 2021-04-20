import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:tendon_loader/utils/app/constants.dart' show Images;

class CustomImage extends StatelessWidget with Images {
  const CustomImage({
    Key key,
    this.name = Images.IMG_APP_LOGO,
    this.isLogo = false,
    this.radius = 100,
    this.isBg = false,
  })  : path = Images.IMG_ROOT + name,
        super(key: key);

  final bool isBg;
  final bool isLogo;
  final String name;
  final String path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Color _accent = Theme.of(context).accentColor;
    final Color _primary = Theme.of(context).primaryColor;
    if (isLogo) {
      return Container(
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.all(isLogo ? 30 : 0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: _primary, border: Border.all(width: 3, color: _accent)),
        child: CircleAvatar(radius: radius, backgroundColor: _primary, child: SvgPicture.asset(path, color: _accent)),
      );
    } else if (isBg) {
      return Expanded(child: SvgPicture.asset(path, color: _accent));
    } else {
      return Image.asset(path);
    }
  }
}
