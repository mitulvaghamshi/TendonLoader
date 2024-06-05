import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  const factory AppLogo.square({
    final EdgeInsetsGeometry? padding,
    final double? radius,
  }) = _AppLogoSquare;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context)
        .colorScheme
        .primary
        .value
        .toRadixString(16)
        .substring(2);
    final circle =
        '<circle cx="200" cy="200" r="197" fill="none" stroke="#$color" stroke-width="7"/>';
    final logo = '<path fill="#$color" d="${Strings.appLogoSvgData}"/></svg>';
    return SvgPicture.string('${Strings.appLogoSvgNs}$circle$logo');
  }
}

@immutable
class _AppLogoSquare extends AppLogo {
  const _AppLogoSquare({this.padding, this.radius});

  final EdgeInsetsGeometry? padding;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        maxRadius: radius ?? 150,
        child: const AppLogo(),
      ),
    );
  }
}
