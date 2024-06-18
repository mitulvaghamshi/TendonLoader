import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class RawButton extends StatelessWidget {
  const RawButton({
    super.key,
    this.color,
    this.child,
    this.onTap,
    this.radius,
    this.padding = const EdgeInsets.all(16),
  });

  const factory RawButton.tile({
    final Key? key,
    final Widget? child,
    final Color? color,
    final double? radius,
    final VoidCallback? onTap,
    final EdgeInsetsGeometry padding,
    final Widget? leading,
    final Widget? trailing,
    final double spacing,
    final MainAxisSize axisSize,
    final MainAxisAlignment axisAlignment,
  }) = _RawListTile;

  const factory RawButton.loading({final bool scaffold}) = _RawLoading;

  const factory RawButton.error({final String message}) = _RawError;

  final Widget? child;
  final Color? color;
  final double? radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final button = RawMaterialButton(
      onPressed: onTap,
      padding: padding,
      fillColor: color,
      child: child,
    );
    if (radius == null) return button;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!),
      child: button,
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
    super.padding,
    super.child,
    this.leading,
    this.trailing,
    this.spacing = 5,
    this.axisSize = MainAxisSize.max,
    this.axisAlignment = MainAxisAlignment.center,
  });

  final Widget? leading;
  final Widget? trailing;
  final double? spacing;
  final MainAxisSize axisSize;
  final MainAxisAlignment axisAlignment;

  @override
  Widget build(BuildContext context) {
    final items = [
      if (leading != null) ...[leading!, SizedBox(width: spacing)],
      if (child != null) child!,
      if (trailing != null) ...[const Spacer(), trailing!],
    ];
    return RawButton(
      onTap: onTap,
      color: color,
      radius: radius,
      padding: padding,
      child: Row(
        mainAxisAlignment: axisAlignment,
        mainAxisSize: axisSize,
        children: items,
      ),
    );
  }
}

@immutable
class _RawLoading extends RawButton {
  const _RawLoading({this.scaffold = false});

  final bool scaffold;

  @override
  Widget build(BuildContext context) {
    const widget = RawButton.tile(
      spacing: 16,
      color: Colors.green,
      leading: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.white,
      ),
      child: Text('Please wait...', style: Styles.whiteBold),
    );
    if (!scaffold) return widget;
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: widget),
      ),
    );
  }
}

@immutable
class _RawError extends RawButton {
  const _RawError({this.message = 'Something went wrong'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return RawButton.tile(
      color: Colors.red,
      child: Text(message, style: Styles.whiteBold),
    );
  }
}
