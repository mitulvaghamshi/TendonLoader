import 'package:flutter/material.dart';

class RawButton extends StatelessWidget {
  const RawButton({
    super.key,
    this.onTap,
    this.radius,
    this.color,
    required this.child,
  });

  factory RawButton.icon({
    final VoidCallback? onTap,
    final Color? color,
    final double? radius,
    required Widget left,
    required Widget right,
  }) {
    return RawButton(
      onTap: onTap,
      color: color,
      radius: radius,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [left, const SizedBox(width: 5), right],
      ),
    );
  }

  factory RawButton.extended({
    final VoidCallback? onTap,
    final Color? color,
    final double? radius,
    required final Widget child,
  }) {
    return RawButton(
      onTap: onTap,
      color: color,
      radius: radius,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      ),
    );
  }

  final VoidCallback? onTap;
  final double? radius;
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 4),
      child: RawMaterialButton(
        constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
        padding: const EdgeInsets.all(16),
        onPressed: onTap,
        fillColor: color,
        child: child,
      ),
    );
  }
}
