import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      shadowColor: Colors.black,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
