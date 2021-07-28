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
  }) : super(key: key);

  final Color? color;
  final bool rounded;
  final double radius;
  final Widget? left;
  final Widget? right;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 16,
      onPressed: onPressed ?? () {},
      padding: const EdgeInsets.all(12),
      fillColor: color ?? Theme.of(context).buttonColor,
      shape: rounded ? const CircleBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      constraints:
          rounded ? BoxConstraints.loose(Size.fromRadius(radius)) : const BoxConstraints(minWidth: 30, minHeight: 30),
      child: rounded || left == null || right == null
          ? left ?? right
          : Row(mainAxisSize: MainAxisSize.min, children: <Widget>[left!, const SizedBox(width: 5), right!]),
    );
  }
}