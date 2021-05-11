import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  String get _deviceName => device.name.isEmpty ? device.id.toString() : device.name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        final bool _isConnected = snapshot.data == BluetoothDeviceState.connected;
        return ListTile(
          horizontalTitleGap: 0,
          title: Text(_deviceName),
          contentPadding: const EdgeInsets.all(5),
          subtitle: Text('Click to ${_isConnected ? 'dis' : ''}connect'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => _isConnected ? Bluetooth.disconnect(device) : Bluetooth.connect(device),
          leading: Icon(_isConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_rounded, size: 40),
          trailing: CircleAvatar(radius: 20, backgroundColor: _isConnected ? Colors.green : Colors.deepOrange),
        );
      },
    );
  }
}
