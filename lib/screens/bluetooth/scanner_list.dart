import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/screens/bluetooth/device_list.dart';
import 'package:tendon_loader/screens/bluetooth/widgets/bluetooth_tile.dart';

/// This class queries data from last Scan using
/// [FlutterBlue.instance.scanResults] stream, it will retrieve
/// and show scanned devices. Can be multiple or none.
/// This is a Stream, yet one time process...
/// No interactive content in this widget.
class ScannerList extends StatelessWidget {
  const ScannerList({super.key});

  Stream<Iterable<BluetoothDevice>> _getScanResult() {
    return FlutterBlue.instance.scanResults
        .asyncMap((List<ScanResult> results) {
      return results.map((ScanResult result) => result.device);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<BluetoothDevice>>(
      stream: _getScanResult(),
      builder: (_, AsyncSnapshot<Iterable<BluetoothDevice>> snapshot) {
        // Show Loading... while data is fetching...
        if (!snapshot.hasData) return const LoadingWidget();
        // If Scan result is empty, check if Bluetooth is enabled...
        if (snapshot.data!.isEmpty) return const BluetoothTile();
        // otherwise, Move to Device list, which shows all the scanned devices.
        return DeviceList(devices: snapshot.data!);
      },
    );
  }
}
