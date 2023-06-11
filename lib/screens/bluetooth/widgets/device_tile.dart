import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/screens/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/screens/bluetooth/widgets/connected_tile.dart';
import 'package:tendon_loader/screens/bluetooth/widgets/disconnected_tile.dart';

/// A single "Progressor" device (Connected or Disconnected).
/// This widget will allows to restart the "Scanning..." process,
/// if no devices found during first scan.
class DeviceTile extends StatelessWidget with Progressor {
  const DeviceTile({super.key, required this.device, this.isLast = false});

  final BluetoothDevice device;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return ConnectedTile(device: device);
        }
        if (isLast) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            DisconnectedTile(device: device),
            CustomWidget.two(
              left: const Icon(Icons.search),
              right: const Text('Scan'),
              onPressed: startScan,
            ),
          ]);
        }
        return DisconnectedTile(device: device);
      },
    );
  }
}
