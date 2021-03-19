import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    this.scale = 0.6,
    this.zeroPad = false,
    this.dir = 'assets/images/',
    this.name = 'ic_launcher.webp',
  }) : this.path = dir + name;

  final String dir;
  final String name;
  final String path;
  final double scale;
  final bool zeroPad;

  @override
  Widget build(BuildContext context) {
    if (zeroPad)
      return Image.asset(path);
    else
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(path, height: MediaQuery.of(context).size.width * scale),
      );
  }
}
