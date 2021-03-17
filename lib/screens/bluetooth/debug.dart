import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class Debug extends StatelessWidget {
  static const routeName = '/debug';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Progressor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<BluetoothDevice>>(
          initialData: [],
          stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
          builder: (_, snapshot) {
            return Column(
              children: snapshot.data.map((device) {
                return ExpansionTile(
                  title: Text(device.name),
                  children: [
                    StreamBuilder<int>(
                      stream: device.mtu,
                      builder: (_, snapshot) {
                        return ListTile(
                          title: Text('Request MTU (max: 128)'),
                          subtitle: Text('current mtu: ${snapshot.data ?? '---'}'),
                          onTap: () async => await Bluetooth.device.requestMtu(128),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Click to Tare'),
                      onTap: () async => await Bluetooth.instance.write(100),
                    ),
                    ListTile(
                      title: Text('Start Measuring'),
                      onTap: () async => await Bluetooth.instance.startWeightMeas(),
                    ),
                    ListTile(
                      title: Text('Stop Measuring'),
                      onTap: () async => await Bluetooth.instance.stopWeightMeas(),
                    ),
                    ListTile(
                      title: Text('Start Notify'),
                      onTap: () async => await Bluetooth.instance.startNotify(),
                    ),
                    ListTile(
                      title: Text('Stop Notify'),
                      onTap: () async => await Bluetooth.instance.stopNotify(),
                    ),
                    ListTile(
                      title: Text('Disconnect'),
                      onTap: () async => await device.disconnect(),
                    ),
                    ListTile(
                      title: Text('Sleep'),
                      onTap: () async => await Bluetooth.instance.sleep(),
                    ),
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
