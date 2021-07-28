import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.left,
    this.right,
    this.color,
    this.onPressed,
    this.radius = 30,
  })  : _extended = left != null && right != null,
        super(key: key);

  final Widget? left;
  final Widget? right;
  final Color? color;
  final double radius;
  final bool _extended;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (_extended) {
      return RawMaterialButton(
        elevation: 16,
        onPressed: onPressed ?? () {},
        padding: const EdgeInsets.all(12),
        fillColor: color ?? Theme.of(context).buttonColor,
        constraints: const BoxConstraints(minHeight: 25, minWidth: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[left!, const SizedBox(width: 5), right!]),
      );
    } else {
      return RawMaterialButton(
        elevation: 16,
        shape: const CircleBorder(),
        onPressed: onPressed ?? () {},
        fillColor: color ?? Theme.of(context).buttonColor,
        constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0x00000000),
          foregroundColor: color != null ? colorWhite : Theme.of(context).accentColor,
          child: left ?? right,
        ),
      );
    }
  }
}
