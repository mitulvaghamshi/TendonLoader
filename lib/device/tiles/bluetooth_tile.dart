import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' show BluetoothState, FlutterBlue;
import 'package:tendon_loader/device/tiles/enable_bluetooth_tile.dart' show EnableBluetoothTile;
import 'package:tendon_loader/device/tiles/location_tile.dart' show LocationTile;

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      initialData: BluetoothState.unknown,
      stream: FlutterBlue.instance.state,
      builder: (_, AsyncSnapshot<BluetoothState> snapshot) {
        return snapshot.data == BluetoothState.on ? const LocationTile() : const EnableBluetoothTile();
      },
    );
  }
}
