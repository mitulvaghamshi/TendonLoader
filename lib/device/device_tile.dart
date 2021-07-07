import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/device/connected_tile.dart';
import 'package:tendon_loader/utils/themes.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  String get _deviceName => device.name.isEmpty ? device.id.id : device.name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        if (_deviceName.contains('Progressor')) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            return ConnectedTile(device: device, deviceName: _deviceName);
          } else {
            return ListTile(
              onTap: device.connect,
              contentPadding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12)),
              title: Text(_deviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
              leading: CustomButton(
                radius: 25,
                color: red400,
                onPressed: () {},
                icon: const Icon(Icons.bluetooth_rounded, size: 30),
              ),
            );
          }
        } else {
          return ListTile(
            title: Text(_deviceName),
            contentPadding: const EdgeInsets.all(5),
            subtitle: const Text('Can not connect', style: TextStyle(fontSize: 12)),
            leading: CustomButton(radius: 25, icon: const Icon(Icons.block, size: 30), onPressed: () {}),
          );
        }
      },
    );
  }
}
