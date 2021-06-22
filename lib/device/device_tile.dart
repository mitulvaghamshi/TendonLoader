import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/colors.dart';
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
            if (_isConnected) {
              return ListTile(
                horizontalTitleGap: 0,
                title: Text(_deviceName),
                contentPadding: const EdgeInsets.all(5),
                onLongPress: () => disconnectDevice(device),
                leading: const Icon(Icons.bluetooth_connected_rounded, size: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                trailing: const CircleAvatar(radius: 20, backgroundColor: colorGoogleGreen),
                subtitle: const Text('Long press to disconnect', style: TextStyle(fontSize: 12, color: colorOrange400)),
              );
            } else {
              return ListTile(
                horizontalTitleGap: 0,
                title: Text(_deviceName),
                onTap: () => connectDevice(device),
                contentPadding: const EdgeInsets.all(5),
                leading: const Icon(Icons.bluetooth_rounded, size: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                trailing: const CircleAvatar(radius: 20, backgroundColor: colorOrange400),
                subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12, color: colorGoogleGreen)),
              );
            }
          },
        );
      },
    );
  }
}
