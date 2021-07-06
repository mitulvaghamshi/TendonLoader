import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/handler/device_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/themes.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key? key, required this.device, required this.deviceName}) : super(key: key);

  final String deviceName;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return _ConnectedTile(device: device, deviceName: deviceName);
        } else {
          return _DisconnectedTile(device: device, deviceName: deviceName);
        }
      },
    );
  }
}

class _ConnectedTile extends StatelessWidget {
  const _ConnectedTile({Key? key, required this.device, required this.deviceName}) : super(key: key);

  final String deviceName;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      initialData: false,
      future: getProps(device),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData || snapshot.data!) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text(deviceName),
              onLongPress: disconnectDevice,
              contentPadding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              subtitle: const Text('Long press to disconnect', style: TextStyle(fontSize: 12, color: red400)),
              leading: const CustomButton(
                radius: 25,
                color: googleGreen,
                icon: Icon(Icons.bluetooth_connected_rounded, size: 30),
              ),
            ),
            StreamBuilder<ChartData>(
              initialData: ChartData(),
              stream: graphDataStream,
              builder: (_, AsyncSnapshot<ChartData> snapshot) => Text(
                '${snapshot.data!.load} Kg.',
                style: const TextStyle(color: googleGreen, fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () => stopTaring().then((_) => Navigator.pop(context)),
              icon: const Icon(Icons.build_circle_rounded),
              child: const Text('Tare Progressor'),
            ),
          ]);
        } else {
          return const CustomProgress(text: 'Connecting...');
        }
      },
    );
  }
}

class _DisconnectedTile extends StatelessWidget {
  const _DisconnectedTile({Key? key, required this.device, required this.deviceName}) : super(key: key);

  final String deviceName;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: device.connect,
      title: Text(deviceName),
      contentPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12, color: googleGreen)),
      leading: const CustomButton(color: red400, radius: 25, icon: Icon(Icons.bluetooth_rounded, size: 30)),
    );
  }
}
