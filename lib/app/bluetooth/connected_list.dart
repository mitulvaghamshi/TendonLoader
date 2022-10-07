import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/device_list.dart';
import 'package:tendon_loader/app/bluetooth/widgets/scanning_tile.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';

/// The app uses [FlutterBlue.instance.connectedDevices] stream to look for
/// already connected Bluetooth devices. The connection is with the
/// mobile device itself and not to the specific application, meaning closing
/// app may keep device to stay connected. So, app is responsible to disconnect
/// the Progressor and close any connection.
/// Here, using this widget to check if there is any device alredy connected
/// and avaiable to use without searching for a new device.
class ConnectedList extends StatelessWidget {
  const ConnectedList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (!snapshot.hasData) {
          return const CustomTile(
            title: 'Please wait...',
            left: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.data!.isEmpty) return const ScanningTile();
        return DeviceList(devices: snapshot.data!);
      },
    );
  }
}
