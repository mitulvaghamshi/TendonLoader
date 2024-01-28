import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

/// A Bluetooth device which is ready and waiting to connect.
/// This device is the only "Tindeq Progressor" bluetooth device.
/// "Click" the device name to establish the connection, and start working.
@immutable
class DisconnectedTile extends StatelessWidget {
  const DisconnectedTile({super.key, required this.device});

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: device.connect,
      contentPadding: const EdgeInsets.all(5),
      leading: FloatingActionButton(
        onPressed: device.connect,
        heroTag: 'disconnected-tile-tag',
        backgroundColor: const Color(0xffff534d),
        child: const Icon(Icons.bluetooth, color: Color(0xffffffff)),
      ),
      title: Text(
        device.name.isEmpty ? device.id.id : device.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12)),
    );
  }
}
