import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.text = 'Click',
    this.icon,
    this.color,
    this.background,
    this.onPressed,
    this.withText = true,
  }) : super(key: key);

  final String text;
  final Color color;
  final IconData icon;
  final bool withText;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (withText) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Theme.of(context).accentColor),
        label: Text(text, style: TextStyle(color: color ?? Theme.of(context).accentColor)),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(16),
          visualDensity: const VisualDensity(vertical: 1.5, horizontal: 2),
          backgroundColor: MaterialStateProperty.all<Color>(background ?? Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
        ),
      );
    } else {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Theme.of(context).accentColor),
      );
    }
  }
}
