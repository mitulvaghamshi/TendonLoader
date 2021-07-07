import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/device/connected_tile.dart';
import 'package:tendon_loader/device/scanner_list.dart';

class ConnectedList extends StatelessWidget {
  const ConnectedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      // initialData: const <BluetoothDevice>[],
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
              children: snapshot.data!.map((BluetoothDevice device) {
            return ConnectedTile(device: device, deviceName: device.name.isEmpty ? device.id.id : device.name);
          }).toList());
        }
        return const ScannerList();
      },
    );
  }
}
