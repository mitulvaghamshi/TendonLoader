import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar(this.text, {Key? key, this.color}) : super(key: key);

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color ?? Theme.of(context).accentColor,
      foregroundColor: color != null ? Colors.white : Theme.of(context).primaryColor,
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
