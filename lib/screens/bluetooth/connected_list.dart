import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/screens/bluetooth/device_list.dart';
import 'package:tendon_loader/screens/bluetooth/scanning_tile.dart';

/// The app uses [FlutterBlue.instance.connectedDevices] stream to look for
/// already connected Bluetooth devices. The connection is with the
/// mobile device itself and not to the specific application, meaning closing
/// app may keep device to stay connected. So, app is responsible to disconnect
/// the Progressor and close any connection.
/// Here, using this class to check if there is any device alredy connected
/// and avaiable to use without searching for a new device.
/// This is one time process...
/// No interactive content in this widget.
class ConnectedList extends StatelessWidget {
  const ConnectedList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        // Initial Step... Loading...
        if (!snapshot.hasData) return const LoadingWidget();
        // Could not find any connected device, Goto Device Scanner...
        if (snapshot.data!.isEmpty) return const ScanningTile();
        // else, Show the list of connected devices...
        return DeviceList(devices: snapshot.data!);
      },
    );
  }
}
