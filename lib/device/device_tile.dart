import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' show BluetoothDevice, BluetoothDeviceState;
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart' show connectDevice, disconnectDevice, isDeviceConnecting;

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key? key, this.device}) : super(key: key);

  final BluetoothDevice? device;

  String get _deviceName => device!.name.isEmpty ? device!.id.id : device!.name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device!.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        final bool _isConnected = snapshot.data == BluetoothDeviceState.connected;
        return StreamBuilder<bool>(
          initialData: false,
          stream: isDeviceConnecting,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data!) return const CustomProgress(text: 'Connecting...');
            return ListTile(
              horizontalTitleGap: 0,
              title: Text(_deviceName),
              contentPadding: const EdgeInsets.all(5),
              onTap: () => connectDevice(device),
              onLongPress: () => disconnectDevice(device),
              subtitle: Text(
                _isConnected ? 'Long press to disconnect' : 'Click to connect',
                style: const TextStyle(fontSize: 12),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: Icon(_isConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_rounded, size: 40),
              trailing: CircleAvatar(radius: 20, backgroundColor: _isConnected ? Colors.green : Colors.deepOrange),
            );
          },
        );
      },
    );
  }
}
