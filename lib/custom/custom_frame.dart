import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({
    Key? key,
    this.child,
    this.onExit,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Future<bool> Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onExit ?? () async => true,
      child: Card(
        elevation: 16,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
