import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/pages/bluetooth/widgets/connected_tile.dart';
import 'package:tendon_loader/pages/bluetooth/widgets/disconnected_tile.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';

/// A single "Progressor" device (Connected or Disconnected).
/// This widget will allows to restart the "Scanning..." process,
/// if no devices found during first scan.
@immutable
class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device, this.isLast = false});

  final BluetoothDevice device;
  final bool isLast;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: device.state,
    builder: (context, snapshot) {
      if (snapshot.data == .connected) {
        return ConnectedTile(device: device);
      }
      if (!isLast) {
        return DisconnectedTile(device: device);
      }
      return Column(
        mainAxisSize: .min,
        children: [
          DisconnectedTile(device: device),
          ButtonFactory.tile(
            onTap: Progressor.instance.scan,
            leading: const Icon(Icons.search),
            child: const Text('Scan'),
          ),
        ],
      );
    },
  );
}
