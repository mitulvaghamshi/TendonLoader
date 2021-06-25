import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';

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
          stream: connectionStream,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data!) return const CustomProgress(text: 'Connecting...');
            return ListTile(
              title: Text(_deviceName),
              contentPadding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                if (!_isConnected) connectDevice(device);
              },
              onLongPress: () {
                if (_isConnected) disconnectDevice(device);
              },
              leading: _isConnected
                  ? const CustomButton(
                      color: googleGreen,
                      icon: Icon(Icons.bluetooth_connected_rounded, size: 35),
                    )
                  : const CustomButton(
                      color: red400,
                      icon: Icon(Icons.bluetooth_rounded, size: 35),
                    ),
              subtitle: _isConnected
                  ? const Text(
                      'Long press to disconnect',
                      style: TextStyle(fontSize: 12, color: red400),
                    )
                  : const Text(
                      'Click to connect',
                      style: TextStyle(fontSize: 12, color: googleGreen),
                    ),
            );
          },
        );
      },
    );
  }
}
