import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/device_tile.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/start_scan_tile.dart';

/// This class will show a list of Bluetooth devices, where user can
/// connect to any device.
/// The app is restricted to show only "Tindeq Progressor"s,
/// so a full list of scanned devices gets filtered-out before user can see.
/// User can "Click" on any device to "Connect" to, and "Long Press" on any
/// already connected device to "Disconnect".
/// The "Connect" and "Disconnect" are very important steps to successfully
/// perform actual tasks of "Exercise" and "MVC Test".
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
}

extension on DeviceList {
  Iterable<Widget> _buildDeviceItem() sync* {
    final Iterator<BluetoothDevice> iterator = _devices.iterator;
    final bool isNotEmpty = iterator.moveNext();
    BluetoothDevice device = iterator.current;
    while (iterator.moveNext()) {
      yield DeviceTile(device: device);
      device = iterator.current;
    }
    if (isNotEmpty) {
      yield DeviceTile(device: device, isLast: true);
    }
  }
}

/// Filter out Scanned result to include only device that contains
/// the name "Progressor", as all the "Tindeq Progressor" devices are
/// named in "Progressor_xxxx" pattern, where, "xxxx" is the four digit
/// unique (serial) number.
Iterable<BluetoothDevice> _filterList(Iterable<BluetoothDevice> devices) {
  return devices.where((device) {
    return device.name.contains('Progressor');
  });
}
