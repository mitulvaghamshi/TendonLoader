import 'dart:developer';

import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    this.dir = 'assets/images/',
    this.image = 'ic_launcher.webp',
    this.scale = 0.6,
  }) : this.path = dir + image;

  final String dir;
  final String image;
  final String path;
  final double scale;

  @override
  Widget build(BuildContext context) {
    log('called');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Image.asset(path, height: MediaQuery.of(context).size.width * scale),
    );
  }
}
