import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/screens/device/connected_tile.dart';
import 'package:tendon_loader/utils/themes.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({Key? key, required this.devices}) : super(key: key);

  final Iterable<BluetoothDevice> devices;

  String _nameOf(BluetoothDevice device) => device.name.isEmpty ? device.id.id : device.name;

  @override
  Widget build(BuildContext context) {
    // TODO(mitul): UI not feasible with multiple progressor found in scan result, provide-github-issue-url
    // Issue: if device is not connected, and multiple progressors enabled,
    // the list will show as many scan buttons as many progressor found.
    return Column(
        children: devices.where((BluetoothDevice device) {
      return device.name.contains('Progressor');
    }).map((BluetoothDevice device) {
      return StreamBuilder<BluetoothDeviceState>(
        stream: device.state,
        builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) return ConnectedTile(device: device);
          return Column(children: <Widget>[
            ListTile(
              onTap: device.connect,
              contentPadding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12)),
              title: Text(_nameOf(device), style: const TextStyle(fontWeight: FontWeight.bold)),
              leading: const CustomButton(
                color: colorRed400,
                left: Icon(Icons.bluetooth, color: colorWhite, size: 30),
              ),
            ),
            const CustomButton(left: Icon(Icons.search), onPressed: startScan, right: Text('Scan')),
          ]);
        },
      );
    }).toList());
  }
}
