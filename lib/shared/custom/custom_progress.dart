import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({Key? key, this.text = 'Please wait...'}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircularProgressIndicator(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
      title: Text(text, style: const TextStyle(fontSize: 20, fontFamily: 'Georgia')),
    );
  }
}
