import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/bluetooth/device.dart';
import 'package:tendon_loader/screens/bluetooth/scanner.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: [],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, snapshot) {
        if (snapshot.data.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
                builder: (_, snapshot) {
                  return Column(
                    children: snapshot.data.map((device) {
                      Bluetooth.instance.setDevice(device);
                      return ExpansionTile(
                        title: Text(device.name),
                        children: [
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
                            title: Text('Start Notify'),
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
              ...snapshot.data.map((r) {
                Bluetooth.instance.setDevice(r.device);
                return StreamBuilder<BluetoothDeviceState>(
                  stream: r.device.state,
                  builder: (_, snapshot) => Device(state: snapshot.data),
                );
              }),
            ],
          );
        } else {
          return Scanner();
        }
      },
    );
  }
}
