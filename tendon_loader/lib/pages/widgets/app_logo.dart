import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class const AppLogo({
  super.key,
  final double? radius,
  final EdgeInsetsGeometry? padding,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary
        .toARGB32()
        .toRadixString(16)
        .substring(2);
    final circle =
        '<circle cx="200" cy="200" r="197" fill="none" stroke="#$color" stroke-width="7"/>';
    final logo = '<path fill="#$color" d="${Strings.appLogoSvgData}"/></svg>';

    Widget widget = SvgPicture.string('${Strings.appLogoSvgNs}$circle$logo');

    if (radius != null) {
      widget = CircleAvatar(
        backgroundColor: Colors.transparent,
        maxRadius: radius,
        child: widget,
      );
    }
    if (padding == null) {
      return widget;
    }

    return Padding(padding: padding!, child: widget);
  }
}
