import 'package:flutter/material.dart';

@immutable
class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      frameBuilder: (_, child, frame, ___) {
        return AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: frame == null ? 0 : 1,
          child: child,
        );
      },
    );
  }
}
