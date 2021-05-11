import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.icon,
    this.color,
    this.iSize,
    this.background,
    this.onPressed,
    this.text = 'Click',
    this.withText = true,
    this.simple = false,
  }) : super(key: key);

  final String text;
  final Color color;
  final double iSize;
  final IconData icon;
  final bool simple;
  final bool withText;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (simple) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iSize, color: color ?? Theme.of(context).accentColor),
        label: Text(text, style: TextStyle(color: color ?? Theme.of(context).accentColor)),
      );
    } else if (withText) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iSize, color: color ?? Theme.of(context).accentColor),
        label: Text(text, style: TextStyle(color: color ?? Theme.of(context).accentColor)),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(16),
          visualDensity: const VisualDensity(vertical: 1.5, horizontal: 2),
          backgroundColor: MaterialStateProperty.all<Color>(background ?? Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: onPressed,
        iconSize: iSize ?? 24,
        icon: Icon(icon, color: color ?? Theme.of(context).accentColor),
      );
    }
  }
}
