import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key, this.size = 300}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: size, maxWidth: size),
      padding: EdgeInsets.all(size < 300 ? 0 : 16),
      child: SvgPicture.asset(
        'packages/tendon_loader_lib/assets/images/app_logo.svg',
        excludeFromSemantics: true,
        color: Theme.of(context).accentColor,
        placeholderBuilder: (_) => const SizedBox(),
      ),
    );
  }
}
