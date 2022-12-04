import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/common/constants.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    this.name,
    this.maxSize,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String? name;
  final double? maxSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (name != null && name!.isNotEmpty) {
      return Image.asset(
        name!,
        fit: BoxFit.contain,
        frameBuilder: (_, Widget child, int? frame, ___) => AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: frame == null ? 0 : 1,
          child: child,
        ),
      );
    }
    return FittedBox(
      child: Padding(
        padding: padding,
        child: CircleAvatar(
          minRadius: 10,
          maxRadius: maxSize,
          backgroundColor: const Color(0x00000000),
          child: SvgPicture.asset(
            Images.appLogo,
          ),
        ),
      ),
    );
  }
}
