import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/lists/device_list.dart';
import 'package:tendon_loader/bluetooth/tiles/bluetooth_tile.dart';
import 'package:tendon_loader/custom/custom_progress.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<BluetoothDevice>>(
      stream: FlutterBlue.instance.scanResults.asyncMap(
          (List<ScanResult> results) =>
              results.map((ScanResult result) => result.device)),
      builder: (_, AsyncSnapshot<Iterable<BluetoothDevice>> snapshot) {
        if (!snapshot.hasData) return const CustomProgress();
        return snapshot.data!.isEmpty
            ? const BluetoothTile()
            : DeviceList(devices: snapshot.data!);
      },
    );
  }
}
