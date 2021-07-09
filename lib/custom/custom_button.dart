import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.child,
    this.icon,
    this.color,
    this.onPressed,
    this.radius = 30,
    this.elevation = 16,
    this.reverce = false,
  })  : _extended = child != null && icon != null,
        super(key: key);

  final Icon? icon;
  final Color? color;
  final Widget? child;
  final bool reverce;
  final double radius;
  final bool _extended;
  final double elevation;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget _child;
    if (_extended) {
      final List<Widget> list = <Widget>[icon!, const SizedBox(width: 5), child!];
      _child = Row(mainAxisSize: MainAxisSize.min, children: reverce ? list.reversed.toList() : list);
    } else {
      _child = CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        foregroundColor: color != null ? Colors.white : Theme.of(context).accentColor,
        child: child ?? icon,
      );
    }
    return RawMaterialButton(
      elevation: elevation,
      onPressed: onPressed ?? () {},
      padding: EdgeInsets.all(_extended ? 12 : 0),
      fillColor: color ?? Theme.of(context).buttonColor,
      constraints: const BoxConstraints(minHeight: 25, minWidth: 25),
      shape: _extended ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)) : const CircleBorder(),
      child: _child,
    );
  }
}
