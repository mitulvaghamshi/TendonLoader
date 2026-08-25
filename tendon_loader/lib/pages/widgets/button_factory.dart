import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class const ButtonFactory({
  super.key,
  final Color? color,
  final Widget? child,
  final VoidCallback? onTap,
  final double radius = 8,
  final EdgeInsetsGeometry padding = const .all(16),
}) extends StatelessWidget {
  const factory loading({bool centered}) = _RawLoading;

  const factory error({Color? color, String message}) = _RawError;

  const factory tile({
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

  @override
  Widget build(BuildContext context) {
    final button = RawMaterialButton(
      onPressed: onTap,
      padding: padding,
      fillColor: color,
      child: child,
    );

    if (radius == 0) {
      return button;
    }

    return ClipRRect(borderRadius: .circular(radius), child: button);
  }
}

@immutable
class const _RawListTile({
  super.key,
  super.onTap,
  super.color,
  super.radius,
  super.padding,
  super.child,
  final Widget? leading,
  final Widget? trailing,
  final double? spacing = 5,
  final MainAxisSize axisSize = .max,
  final MainAxisAlignment axisAlignment = .center,
}) extends ButtonFactory {
  @override
  Widget build(BuildContext context) {
    final items = [
      if (leading != null) ...[?leading, SizedBox(width: spacing)],
      ?child,
      if (trailing != null) ...[const Spacer(), ?trailing],
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
class const _RawLoading({final bool centered = false}) extends ButtonFactory {
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

    if (!centered) {
      return widget;
    }

    return const Padding(
      padding: .all(16),
      child: Center(child: widget),
    );
  }
}

@immutable
class const _RawError({
  super.color = Colors.red,
  final String message = 'Something went wrong',
}) extends ButtonFactory {
  @override
  Widget build(BuildContext context) => ButtonFactory.tile(
    color: color,
    padding: const .all(8),
    leading: const Icon(Icons.info, color: Colors.white),
    trailing: IconButton(
      onPressed: ScaffoldMessenger.of(context).clearSnackBars,
      icon: const Icon(Icons.close, color: Colors.white),
    ),
    child: Text(message, style: const .new(color: Colors.white)),
  );
}
