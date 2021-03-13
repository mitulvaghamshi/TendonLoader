import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/bluetooth/Result.dart';
import 'package:tendon_loader/screens/bluetooth/enable_bluetooth.dart';

class DeviceScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (_, snapshot) => snapshot.data == BluetoothState.on ? Result() : EnableBluetooth(),
    );
  }
}
