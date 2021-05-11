import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        SizedBox(width: 30),
        Text('Please wait...', style: TextStyle(fontSize: 20, fontFamily: 'Georgia')),
      ],
    );
  }
}
