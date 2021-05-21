import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({Key? key, this.child, this.isScrollable = false, this.onExit}) : super(key: key);

  final Widget? child;
  final bool isScrollable;
  final Future<bool> Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onExit ?? () async => true,
      child: Card(
        elevation: 16,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: isScrollable
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: child,
              )
            : Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 30), child: child),
      ),
    );
  }
}
