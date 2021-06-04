import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(name, frameBuilder: (_, Widget child, int? frame, bool wasSync) {
      if (wasSync) return child;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: frame != null ? child : const SizedBox(),
      );
    }, excludeFromSemantics: true);
  }
}
