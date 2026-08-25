import 'package:flutter/material.dart';

@immutable
class const ImageWidget({required final String path, super.key})
    extends StatelessWidget {
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
