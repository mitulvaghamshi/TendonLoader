import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/device/location_tile.dart';
import 'package:tendon_loader/app/device/tiles/enable_bluetooth_tile.dart';

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      initialData: BluetoothState.unknown,
      stream: FlutterBlue.instance.state,
      builder: (_, AsyncSnapshot<BluetoothState> snapshot) {
        return snapshot.data == BluetoothState.on
            ? const LocationTile()
            : const EnableBluetoothTile();
      },
    );
  }
}
