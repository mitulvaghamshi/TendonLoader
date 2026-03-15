import 'package:flutter/material.dart';

@immutable
class AppFrame extends StatelessWidget {
  const AppFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Card.outlined(
    elevation: 16,
    child: Padding(padding: const .all(16), child: child),
  );
}
