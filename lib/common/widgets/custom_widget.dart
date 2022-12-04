import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key, this.child, this.color, this.onPressed});

  factory CustomWidget.two({
    required Widget left,
    required Widget right,
    VoidCallback? onPressed,
    Color? color,
  }) =>
      CustomWidget(
        color: color,
        onPressed: onPressed,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[left, const SizedBox(width: 5), right]),
      );

  final Widget? child;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
      padding: const EdgeInsets.all(16),
      onPressed: onPressed,
      fillColor: color,
      child: child,
    );
  }
}
