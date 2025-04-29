import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/ui/bluetooth/device_list.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/bluetooth_tile.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';

/// This class queries data from last Scan using
/// [FlutterBlue.instance].scanResults stream, it will retrieve
/// and show scanned devices. Can be multiple or none.
/// This is a Stream, yet one time process...
/// No interactive content in this widget.
class ScannerList extends StatelessWidget {
  const ScannerList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<BluetoothDevice>>(
      stream: _getScanResults,
      builder: (context, snapshot) {
        // Show Loading... while data is fetching...
        if (!snapshot.hasData) return const ButtonFactory.loading();
        // If Scan result is empty, check if Bluetooth is enabled...
        if (snapshot.data!.isEmpty) return const BluetoothTile();
        // otherwise, Move to Device list, which shows all the scanned devices.
        return DeviceList(devices: snapshot.data!);
      },
    );
  }
}

extension on ScannerList {
  Stream<Iterable<BluetoothDevice>> get _getScanResults => FlutterBlue
      .instance
      .scanResults
      .asyncMap((results) => results.map((result) => result.device));
}
