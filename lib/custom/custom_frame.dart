import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({
    Key? key,
    this.child,
    this.onExit,
    this.margin = const EdgeInsets.all(16),
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Future<bool> Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onExit ?? () async => true,
      child: Card(
        elevation: 16,
        margin: margin,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
