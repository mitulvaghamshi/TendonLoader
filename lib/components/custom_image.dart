
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    this.dir = 'assets/images/',
    this.name = 'ic_launcher.webp',
    this.scale = 0.6,
  }) : this.path = dir + name;

  final String dir;
  final String name;
  final String path;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Image.asset(path, height: MediaQuery.of(context).size.width * scale),
    );
  }
}
