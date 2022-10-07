import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/bluetooth_handler.dart';
import 'package:tendon_loader/app/bluetooth/widgets/connected_tile.dart';
import 'package:tendon_loader/app/bluetooth/widgets/start_scan_tile.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

Iterable<BluetoothDevice> _filterList(Iterable<BluetoothDevice> devices) {
  return devices.where((BluetoothDevice device) {
    return device.name.contains('Progressor');
  });
}

class DeviceList extends StatelessWidget {
  DeviceList({super.key, required Iterable<BluetoothDevice> devices})
      : _devices = _filterList(devices);

  final Iterable<BluetoothDevice> _devices;

  @override
  Widget build(BuildContext context) {
    if (_devices.isEmpty) return const StartScanTile();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildDeviceItem().toList(),
      ),
    );
  }

  Iterable<Widget> _buildDeviceItem() sync* {
    final Iterator<BluetoothDevice> iterator = _devices.iterator;
    final bool isNotEmpty = iterator.moveNext();
    BluetoothDevice device = iterator.current;
    while (iterator.moveNext()) {
      yield _DeviceTile(device: device);
      device = iterator.current;
    }
    if (isNotEmpty) {
      yield _DeviceTile(device: device, isLast: true);
    }
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, this.isLast = false});

  final BluetoothDevice device;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return ConnectedTile(device: device);
        }
        if (isLast) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            _DisconnectedTile(device: device),
            const ButtonWidget(
              left: Icon(Icons.search),
              right: Text('Scan'),
              onPressed: startScan,
            ),
          ]);
        }
        return _DisconnectedTile(device: device);
      },
    );
  }
}

class _DisconnectedTile extends StatelessWidget {
  const _DisconnectedTile({required this.device});

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: device.connect,
      contentPadding: const EdgeInsets.all(5),
      title: Text(
        device.name.isEmpty ? device.id.id : device.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: const ButtonWidget(
        color: Color(0xffff534d),
        left: Icon(Icons.bluetooth, color: Color(0xffffffff)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12)),
    );
  }
}
