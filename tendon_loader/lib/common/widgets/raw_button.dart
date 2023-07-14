import 'package:flutter/material.dart';

@immutable
final class RawButton extends StatelessWidget {
  const RawButton({
    super.key,
    this.onTap,
    this.color,
    this.radius,
    this.padding,
    this.child,
  });

  const factory RawButton.tile({
    final Key? key,
    final VoidCallback? onTap,
    final Color? color,
    final double? radius,
    final double? leadingToTitleSpace,
    final EdgeInsetsGeometry? padding,
    final MainAxisAlignment? axisAlignment,
    final MainAxisSize? axisSize,
    final Widget? leading,
    final Widget? child,
    final Widget? trailing,
  }) = RawTile;

  final Color? color;
  final double? radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 4),
      child: RawMaterialButton(
        constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
        padding: padding ?? const EdgeInsets.all(16),
        onPressed: onTap,
        fillColor: color,
        child: child,
      ),
    );
  }
}

@immutable
final class RawTile extends RawButton {
  const RawTile({
    super.key,
    super.onTap,
    super.color,
    super.radius,
    this.leadingToTitleSpace = 5,
    super.padding,
    this.axisAlignment,
    this.axisSize,
    this.leading,
    this.trailing,
    super.child,
  });

  final double? leadingToTitleSpace;
  final MainAxisAlignment? axisAlignment;
  final MainAxisSize? axisSize;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return RawButton(
      onTap: onTap,
      color: color,
      radius: radius,
      padding: padding,
      child: Row(
        mainAxisSize: axisSize ?? MainAxisSize.max,
        mainAxisAlignment: axisAlignment ?? MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: leadingToTitleSpace)
          ],
          if (child != null) child!,
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}
