import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/device/device_tile.dart';
import 'package:tendon_loader/device/scanner_list.dart';

class ConnectedList extends StatelessWidget {
  const ConnectedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      initialData: const <BluetoothDevice>[],
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (snapshot.data!.isEmpty) return const ScannerList();
        return Column(
          children: snapshot.data!.map((BluetoothDevice device) {
            return DeviceTile(device: device, deviceName: device.name.isEmpty ? device.id.id : device.name);
          }).toList(),
        );
      },
    );
  }
}
