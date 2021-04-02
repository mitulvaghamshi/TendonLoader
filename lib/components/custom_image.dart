import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:tendon_loader/utils/constants.dart' show Images;

class CustomImage extends StatelessWidget with Images {
  const CustomImage({Key key, this.name = Images.imgAppLogo, this.isLogo = false, this.radius = 100}) : super(key: key);

  final String name;
  final bool isLogo;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (!isLogo) return Image.asset(Images.imgRoot + name);
    final Color _accent = Theme.of(context).accentColor;
    final Color _primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(shape: BoxShape.circle, color: _primary, border: Border.all(width: 3, color: _accent)),
      child: CircleAvatar(radius: radius, backgroundColor: _primary, child: SvgPicture.asset(Images.imgRoot + name, color: _accent)),
    );
  }
}
