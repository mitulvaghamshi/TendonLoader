import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({
    Key? key,
    this.fSize = 70,
    this.iSize = 30,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final double? fSize;
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
      constraints: BoxConstraints.expand(width: fSize, height: fSize),
      child: Icon(icon, size: iSize),
    );
  }
}
