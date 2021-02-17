import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({this.text = 'Click', this.icon, this.color, this.isFab = false, this.onPressed});

  final String text;
  final IconData icon;
  final Color color;
  final bool isFab;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isFab) {
      return FloatingActionButton(
        child: Icon(icon),
        onPressed: onPressed,
        heroTag: ValueKey(icon),
        backgroundColor: color ?? Colors.black,
      );
    } else {
      return FlatButton.icon(
        onPressed: onPressed,
        color: color ?? Colors.black,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(const Radius.circular(30))),
      );
    }
  }
}
