import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    Key key,
    this.scale = 0.6,
    this.zeroPad = false,
    this.dir = 'assets/images/',
    this.name = 'ic_launcher-playstore.png',
    this.blendColor,
  })  : path = dir + name,
        super(key: key);

  final String dir;
  final String name;
  final String path;
  final double scale;
  final bool zeroPad;
  final Color blendColor;

  @override
  Widget build(BuildContext context) {
    if (zeroPad) {
      return Image.asset(path, color: blendColor);
    } else {
      return Padding(padding: const EdgeInsets.all(16), child: Image.asset(path, height: MediaQuery.of(context).size.width * scale));
    }
  }
}
