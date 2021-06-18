import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar(this.text, {Key? key, this.bgColor}) : super(key: key);

  final String text;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: bgColor ?? Theme.of(context).accentColor,
      foregroundColor: bgColor != null ? Colors.white : Theme.of(context).primaryColor,
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
