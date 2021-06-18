import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({
    Key? key,
    this.size = 70,
    this.iSize = 30,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final double? size;
  final double? iSize;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 16,
      onPressed: onTap,
      shape: const CircleBorder(),
      fillColor: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).accentColor,
      constraints: BoxConstraints.expand(width: size, height: size),
      child: Icon(icon, size: iSize),
    );
  }
}
