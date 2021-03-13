import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/bluetooth/device.dart';
import 'package:tendon_loader/screens/bluetooth/scanner.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: [],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, snapshot) {
        if (snapshot.data.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...snapshot.data.map((r) {
                Bluetooth.instance.setDevice(r.device);
                return StreamBuilder<BluetoothDeviceState>(
                  stream: r.device.state,
                  builder: (_, snapshot) => Device(state: snapshot.data),
                );
              }),
            ],
          );
        } else {
          return Scanner();
        }
      },
    );
  }
}
