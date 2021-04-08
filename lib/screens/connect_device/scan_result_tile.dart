import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/connect_device/device_list.dart';
import 'package:tendon_loader/screens/connect_device/scanner_tile.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: const <ScanResult>[],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) => snapshot.data.isEmpty ? const ScannerTile() : DeviceList(results: snapshot.data),
    );
  }
}
