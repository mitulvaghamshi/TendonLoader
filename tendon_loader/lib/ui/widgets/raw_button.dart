import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constants.dart';

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
    final double? leadingToChildSpace,
    final EdgeInsetsGeometry? padding,
    final MainAxisAlignment? axisAlignment,
    final MainAxisSize? axisSize,
    final Widget? leading,
    final Widget? child,
    final Widget? trailing,
  }) = _RawListTile;

  const factory RawButton.loading() = _RawLoading;

  const factory RawButton.error({bool scaffold, String message}) = _RawError;

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
final class _RawListTile extends RawButton {
  const _RawListTile({
    super.key,
    super.onTap,
    super.color,
    super.radius,
    this.leadingToChildSpace = 5,
    super.padding,
    this.axisAlignment,
    this.axisSize,
    this.leading,
    this.trailing,
    super.child,
  });

  final double? leadingToChildSpace;
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
final class _RawLoading extends RawButton {
  const _RawLoading();

  @override
  Widget build(BuildContext context) {
    return const RawButton.tile(
      radius: 0,
      color: Colors.green,
      leadingToChildSpace: 16,
      leading: CupertinoActivityIndicator(),
      child: Text('Please wait...', style: Styles.boldWhite),
    );
  }
}

@immutable
final class _RawError extends RawButton {
  const _RawError({this.scaffold = true, this.message});

  final bool scaffold;
  final String? message;

  @override
  Widget build(BuildContext context) {
    Widget widget = RawButton.tile(
      radius: 0,
      color: Colors.red,
      child: Text(
        message ?? 'Opss!! Something went wrong',
        style: Styles.boldWhite,
      ),
    );
    if (scaffold) {
      widget = Scaffold(
        appBar: AppBar(title: const Text('Tendon Loader')),
        body: Center(child: widget),
      );
    }
    return widget;
  }
}
