import 'package:flutter/material.dart';

@immutable
class const AppFrame({required final Widget child, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card.outlined(
    elevation: 16,
    child: Padding(padding: const .all(16), child: child),
  );
}
