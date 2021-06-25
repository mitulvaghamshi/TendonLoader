import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.child,
    this.icon,
    this.color,
    this.onPressed,
    this.radius = 30,
    this.reverce = false,
  })  : _extended = child != null && icon != null,
        super(key: key);

  final Icon? icon;
  final Color? color;
  final Widget? child;
  final bool reverce;
  final double radius;
  final bool _extended;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 16,
      onPressed: onPressed,
      padding: EdgeInsets.all(_extended ? 10 : 0),
      fillColor: color ?? Theme.of(context).buttonColor,
      constraints: const BoxConstraints(minHeight: 25, minWidth: 25),
      shape: _extended ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)) : const CircleBorder(),
      child: _extended
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: reverce
                  ? <Widget>[child!, const SizedBox(width: 5), icon!]
                  : <Widget>[icon!, const SizedBox(width: 5), child!])
          : CircleAvatar(
              radius: radius,
              backgroundColor: Colors.transparent,
              foregroundColor: color != null ? Colors.white : Theme.of(context).accentColor,
              child: child ?? icon),
    );
  }
}
