import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ic_launcher-playstore.webp',
      height: MediaQuery.of(context).size.width - 100,
    );
  }
}
