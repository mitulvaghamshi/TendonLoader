import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/device/device_list.dart';
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<BluetoothDevice>>(
      stream: FlutterBlue.instance.scanResults.asyncMap((List<ScanResult> list) =>
          list.where((ScanResult r) => r.device.name.contains('Progressor')).map((ScanResult r) => r.device)),
      builder: (_, AsyncSnapshot<Iterable<BluetoothDevice>> snapshot) {
        if (!snapshot.hasData) return const CustomProgress();
        return snapshot.data!.isEmpty ? const BluetoothTile() : DeviceList(devices: snapshot.data!);
      },
    );
  }
}
