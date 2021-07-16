import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/device/connected_tile.dart';
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart';

class ConnectedList extends StatelessWidget {
  const ConnectedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
              children: snapshot.data!.map((BluetoothDevice device) {
            return ConnectedTile(device: device);
          }).toList());
        }
        return const BluetoothTile();
      },
    );
  }
}
