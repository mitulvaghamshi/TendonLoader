import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class ButtonFactory extends StatelessWidget {
  const ButtonFactory({
    super.key,
    this.color,
    this.child,
    this.onTap,
    this.radius = 8,
    this.padding = const EdgeInsets.all(16),
  });

  const factory ButtonFactory.tile({
    Key? key,
    Widget? child,
    Color? color,
    double radius,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding,
    Widget? leading,
    Widget? trailing,
    double spacing,
    MainAxisSize axisSize,
    MainAxisAlignment axisAlignment,
  }) = _RawListTile;

  const factory ButtonFactory.loading({bool centered}) = _RawLoading;

  const factory ButtonFactory.error({Color? color, String message}) = _RawError;

  final Widget? child;
  final Color? color;
  final double radius;
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
    if (radius == 0) return button;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: button,
    );
  }
}

@immutable
class _RawListTile extends ButtonFactory {
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
    return ButtonFactory(
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
class _RawLoading extends ButtonFactory {
  const _RawLoading({this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    const widget = ButtonFactory.tile(
      spacing: 16,
      color: Colors.green,
      leading: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.white,
      ),
      child: Text('Please wait...', style: Styles.whiteBold),
    );
    if (!centered) return widget;
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: widget),
    );
  }
}

@immutable
class _RawError extends ButtonFactory {
  const _RawError({
    super.color = Colors.red,
    this.message = 'Something went wrong',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return ButtonFactory.tile(
      color: color,
      padding: const EdgeInsets.all(8),
      leading: const Icon(Icons.info, color: Colors.white),
      trailing: IconButton(
        onPressed: ScaffoldMessenger.of(context).clearSnackBars,
        icon: const Icon(Icons.close, color: Colors.white),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white)),
    );
  }
}
