import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/connected_tile.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/disconnected_tile.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

/// A single "Progressor" device (Connected or Disconnected).
/// This widget will allows to restart the "Scanning..." process,
/// if no devices found during first scan.
@immutable
class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device, this.isLast = false});

  final BluetoothDevice device;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (context, snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return ConnectedTile(device: device);
        }
        if (!isLast) return DisconnectedTile(device: device);
        return Column(mainAxisSize: MainAxisSize.min, children: [
          DisconnectedTile(device: device),
          RawButton.tile(
            onTap: Progressor.instance.startScan,
            leading: const Icon(Icons.search),
            child: const Text('Scan'),
          ),
        ]);
      },
    );
  }
}
