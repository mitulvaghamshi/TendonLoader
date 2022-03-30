import 'package:flutter/material.dart';

class FrameWidget extends StatelessWidget {
  const FrameWidget({
    Key? key,
    this.child,
    this.onExit,
    this.margin = const EdgeInsets.all(16),
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry margin;
  final Future<bool> Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onExit ?? () async => true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: child,
      ),
    );
  }
}
