import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/device/tiles/start_scan_tile.dart';
import 'package:tendon_loader/app/device/tiles/stop_scan_tile.dart';

class ScannerTile extends StatelessWidget {
  const ScannerTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data ? const StopScanTile() : const StartScanTile(),
    );
  }
}
