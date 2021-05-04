import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({Key key, this.message = 'Please wait...'}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(width: 30),
        Text(message, style: const TextStyle(fontSize: 20, fontFamily: 'Georgia')),
      ],
    );
  }
}
