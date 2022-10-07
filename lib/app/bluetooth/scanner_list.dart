import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/device_list.dart';
import 'package:tendon_loader/app/bluetooth/widgets/bluetooth_tile.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({super.key});

  Stream<Iterable<BluetoothDevice>> _getScanResults() {
    return FlutterBlue.instance.scanResults
        .asyncMap((List<ScanResult> results) {
      return results.map((ScanResult result) => result.device);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<BluetoothDevice>>(
      stream: _getScanResults(),
      builder: (_, AsyncSnapshot<Iterable<BluetoothDevice>> snapshot) {
        if (!snapshot.hasData) {
          return const CustomTile(
            title: 'Please wait...',
            left: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.data!.isEmpty) return const BluetoothTile();
        return DeviceList(devices: snapshot.data!);
      },
    );
  }
}
