import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/device_list.dart';
import 'package:tendon_loader/app/bluetooth/widgets/scanning_tile.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';

/// Moduele: Connecting Progressor device
/// The app will uses [FlutterBlue.instance.connectedDevices] stream to look
/// for any already connected Bluetooth device with the phone.
/// [NOTE:] A Bluetooth device (LE in this case) is get connected with the mobile
/// device itself and not to the specific application. So, terminating app will keep
/// Bluetooth device to stay connected, and app is responsible to disconnect
/// the Progressor and close the connection when not in use.
///
/// Here, app will utilizes this scheme to check if there is any Bluetooth device
/// alredy avaiable to use without everytime searching for a new device.
class ConnectedList extends StatelessWidget {
  const ConnectedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BluetoothDevice>>(
      future: FlutterBlue.instance.connectedDevices,
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const ScanningTile();
          }
          return DeviceList(devices: snapshot.data!);
        }
        return const CustomTile(
          title: 'Please wait...',
          left: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
