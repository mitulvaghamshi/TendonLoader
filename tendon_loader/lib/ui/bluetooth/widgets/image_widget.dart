import 'package:flutter/material.dart';

@immutable
class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) => Image.asset(
    path,
    fit: .contain,
    frameBuilder: (_, child, frame, _) => AnimatedOpacity(
      duration: const .new(seconds: 2),
      opacity: frame == null ? 0 : 1,
      child: child,
    ),
  );
}
