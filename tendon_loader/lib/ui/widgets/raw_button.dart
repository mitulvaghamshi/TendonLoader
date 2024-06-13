import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class RawButton extends StatelessWidget {
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
    final double? leadingToChildSpace,
    final EdgeInsetsGeometry? padding,
    final MainAxisAlignment? axisAlignment,
    final MainAxisSize? size,
    final Widget? leading,
    final Widget? child,
    final Widget? trailing,
  }) = _RawListTile;

  const factory RawButton.error({bool scaffold, String message}) = _RawError;

  const factory RawButton.loading() = _RawLoading;

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
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding ?? const EdgeInsets.all(16),
        onPressed: onTap,
        fillColor: color,
        child: child,
      ),
    );
  }
}

@immutable
class _RawListTile extends RawButton {
  const _RawListTile({
    super.key,
    super.onTap,
    super.color,
    super.radius,
    this.leadingToChildSpace = 5,
    super.padding,
    this.axisAlignment,
    this.size,
    this.leading,
    this.trailing,
    super.child,
  });

  final double? leadingToChildSpace;
  final MainAxisAlignment? axisAlignment;
  final MainAxisSize? size;
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
        mainAxisSize: size ?? MainAxisSize.max,
        mainAxisAlignment: axisAlignment ?? MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: leadingToChildSpace)
          ],
          if (child != null) child!,
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

@immutable
class _RawError extends RawButton {
  const _RawError({this.scaffold = true, this.message});

  final bool scaffold;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final widget = RawButton.tile(
      radius: 0,
      color: Colors.red,
      child: Text(
        message ?? 'Opps! Something went wrong',
        style: Styles.whiteBold,
      ),
    );
    if (!scaffold) return widget;
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader')),
      body: Center(child: widget),
    );
  }
}

@immutable
class _RawLoading extends RawButton {
  const _RawLoading();

  @override
  Widget build(BuildContext context) {
    return const RawButton.tile(
      radius: 0,
      color: Colors.green,
      leadingToChildSpace: 16,
      leading: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.white,
      ),
      child: Text('Please wait...', style: Styles.whiteBold),
    );
  }
}
