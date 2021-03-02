import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({this.text = 'Click', this.icon, this.color, this.onPressed});

  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      onPressed: onPressed,
      disabledColor: Colors.grey,
      color: color ?? Colors.black,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
