import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/bluetooth/enable_device.dart';
import 'package:tendon_loader/screens/bluetooth/enable_location.dart';
import 'package:tendon_loader/screens/bluetooth/progress.dart';
import 'package:tendon_loader/utils/location.dart' as loc;

class Scanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (c, snapshot) {
        if (snapshot.data) {
          return Progress();
        } else {
          return StreamBuilder<bool>(
            initialData: true,
            stream: loc.Location.stream,
            builder: (_, snapshot) => snapshot.data ? EnableDevice() : EnableLocation(),
          );
        }
      },
    );
  }
}
