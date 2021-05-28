import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' show BluetoothDevice, BluetoothDeviceState;
import 'package:tendon_loader/handler/bluetooth_handler.dart' show Bluetooth;
import 'package:tendon_support_lib/tendon_support_lib.dart' show CustomProgress;

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
          stream: Bluetooth.isConnecting,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data!) return const CustomProgress(text: 'Connecting...');
            return ListTile(
              horizontalTitleGap: 0,
              title: Text(_deviceName),
              contentPadding: const EdgeInsets.all(5),
              onTap: () => Bluetooth.connect(device),
              onLongPress: () => Bluetooth.disconnect(device),
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
