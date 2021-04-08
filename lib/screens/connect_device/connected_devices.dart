import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/connect_device/bluetooth_tile.dart';
import 'package:tendon_loader/screens/connect_device/device_list.dart';

class ConnectedDevices extends StatelessWidget {
  const ConnectedDevices({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
      initialData: const <BluetoothDevice>[],
      stream: Stream<List<BluetoothDevice>>.fromFuture(FlutterBlue.instance.connectedDevices),
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        return snapshot.data.isEmpty ? const BluetoothTile() : DeviceList(devices: snapshot.data);
      },
    );
  }
}
