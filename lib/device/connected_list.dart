import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/device/device_list.dart';
import 'package:tendon_loader/device/tiles/scanner_tile.dart';

class ConnectedList extends StatelessWidget {
  const ConnectedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        return snapshot.hasData && snapshot.data!.isNotEmpty
            ? DeviceList(devices: snapshot.data!)
            : const ScannerTile();
      },
    );
  }
}
