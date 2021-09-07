/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/lists/device_list.dart';
import 'package:tendon_loader/bluetooth/tiles/scanning_tile.dart';
import 'package:tendon_loader/custom/progress_tile.dart';

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
          return const ScanningTile();
        } else {
          return DeviceList(devices: snapshot.data!);
        }
      },
    );
  }
}
