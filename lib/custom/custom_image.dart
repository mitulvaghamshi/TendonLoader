import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(name, frameBuilder: (_, Widget child, int? frame, bool wasSync) {
      if (wasSync) return child;
      return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: frame == null ? 0 : 1,
        child: child,
      );
    }, excludeFromSemantics: true);
  }
}
