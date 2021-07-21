import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/device/tiles/connected_tile.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({Key? key, required this.devices}) : super(key: key);

  final Iterable<BluetoothDevice> devices;

  String _nameOf(BluetoothDevice device) => device.name.isEmpty ? device.id.id : device.name;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: devices.map((BluetoothDevice device) {
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
              leading: const CustomButton(radius: 25, color: colorRed400, icon: Icon(Icons.bluetooth, size: 30)),
            ),
            const CustomButton(icon: Icon(Icons.search), onPressed: startScan, child: Text('Scan')),
          ]);
        },
      );
    }).toList());
  }
}
