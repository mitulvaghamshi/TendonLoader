import 'package:flutter/material.dart';

class FlatButtonIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback callBack;

  FlatButtonIcon(this.text, {this.icon, this.color, this.callBack});

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      onPressed: callBack,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
    );
  }
}
