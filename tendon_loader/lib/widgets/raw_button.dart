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
  }) = _RawListTile;

  const factory RawButton.loading() = _RawLoading;

  final Color? color;
  final double? radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget widget = RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: padding ?? const EdgeInsets.all(16),
      onPressed: onTap,
      fillColor: color,
      child: child,
    );

    if (radius != null) {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: widget,
      );
    }
    return widget;
  }
}

@immutable
final class _RawListTile extends RawButton {
  const _RawListTile({
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

@immutable
final class _RawLoading extends RawButton {
  const _RawLoading();

  @override
  Widget build(BuildContext context) {
    return const RawButton.tile(
      leadingToTitleSpace: 16,
      axisAlignment: MainAxisAlignment.start,
      leading: CircularProgressIndicator.adaptive(),
      child: Text('Please wait...'),
    );
  }
}
