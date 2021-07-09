import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:tendon_loader/custom/custom_button.dart';

@immutable
class AppLogo extends StatelessWidget {
  const AppLogo({Key? key, this.radius = 120}) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      radius: radius,
      child: SvgPicture.asset(
        'assets/images/app_logo.svg',
        color: Theme.of(context).accentColor,
        placeholderBuilder: (_) => const SizedBox(),
      ),
    );
  }
}
