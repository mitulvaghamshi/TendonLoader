import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: CircularProgressIndicator(),
      title: Text('Please wait...', style: TextStyle(fontSize: 20, fontFamily: 'Georgia')),
    );
  }
}
