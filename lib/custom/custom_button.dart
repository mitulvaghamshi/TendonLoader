/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.left,
    this.right,
    this.color,
    this.onPressed,
    this.radius = 30,
    this.rounded = false,
    this.elevation = 16,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  final Color? color;
  final bool rounded;
  final double radius;
  final Widget? left;
  final Widget? right;
  final double? elevation;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: padding,
      elevation: elevation!,
      onPressed: onPressed,
      disabledElevation: elevation!,
      fillColor: color ?? Theme.of(context).buttonColor,
      shape: rounded
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      constraints: rounded
          ? BoxConstraints.tight(Size.fromRadius(radius))
          : const BoxConstraints(minWidth: 30, minHeight: 30),
      child: rounded || left == null || right == null
          ? left ?? right
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[left!, const SizedBox(width: 5), right!],
            ),
    );
  }
}
