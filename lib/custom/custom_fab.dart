import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({Key? key, required this.onTap, required this.icon}) : super(key: key);

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
      constraints: const BoxConstraints.expand(width: 70, height: 70),
      child: Icon(icon, size: 30),
    );
  }
}
