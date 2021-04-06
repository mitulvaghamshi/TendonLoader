import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({Key key, this.child, this.isScrollable = false}) : super(key: key);

  final Widget child;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    if (isScrollable) {
      return Card(
        elevation: 16,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(padding: const EdgeInsets.all(16), physics: const BouncingScrollPhysics(), child: child),
      );
    } else {
      return Card(
        elevation: 16,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 30), child: child),
      );
    }
  }
}
