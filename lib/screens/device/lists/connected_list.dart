import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/screens/device/device_list.dart';
import 'package:tendon_loader/screens/device/tiles/scanner_tile.dart';

class ConnectedList extends StatelessWidget {
  const ConnectedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (!snapshot.hasData) {
          return const CustomProgress();
        } else if (snapshot.data!.isEmpty) {
          return const ScannerTile();
        } else {
          return DeviceList(devices: snapshot.data!);
        }
      },
    );
  }
}
