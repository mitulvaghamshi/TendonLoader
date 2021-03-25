import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class Debug extends StatelessWidget {
  const Debug({Key key}) : super(key: key);

  static const String routeName = '/debug';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Progressor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<BluetoothDevice>>(
          initialData: const <BluetoothDevice>[],
          stream: Stream<List<BluetoothDevice>>.fromFuture(FlutterBlue.instance.connectedDevices),
          builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
            return Column(
              children: snapshot.data.map((BluetoothDevice device) {
                return ExpansionTile(
                  title: Text(device.name),
                  children: <Widget>[
                    StreamBuilder<int>(
                      stream: device.mtu,
                      builder: (_, AsyncSnapshot<int> snapshot) {
                        return ListTile(
                          title: const Text('Request MTU (max: 128)'),
                          subtitle: Text('current mtu: ${snapshot.data ?? '---'}'),
                          onTap: () => Bluetooth.device.requestMtu(128),
                        );
                      },
                    ),
                    ListTile(title: const Text('Click to Tare'), onTap: () => Bluetooth.instance.write(100)),
                    ListTile(title: const Text('Start Measuring'), onTap: () => Bluetooth.instance.startWeightMeas()),
                    ListTile(title: const Text('Stop Measuring'), onTap: () => Bluetooth.instance.stopWeightMeas()),
                    ListTile(title: const Text('Start Notify'), onTap: () => Bluetooth.instance.startNotify()),
                    ListTile(title: const Text('Stop Notify'), onTap: () => Bluetooth.instance.stopNotify()),
                    ListTile(title: const Text('Sleep'), onTap: () => Bluetooth.instance.sleep()),
                    ListTile(title: const Text('Disconnect'), onTap: () => device.disconnect()),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
