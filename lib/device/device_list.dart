import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/images.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/device/device_tile.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FutureBuilder<List<BluetoothDevice>>(
        initialData: const <BluetoothDevice>[],
        future: FlutterBlue.instance.connectedDevices,
        builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
          if (snapshot.data!.isEmpty) {
            return StreamBuilder<List<ScanResult>>(
              initialData: const <ScanResult>[],
              stream: FlutterBlue.instance.scanResults,
              builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) {
                if (snapshot.data!.isEmpty) {
                  return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
                    CustomImage(name: imgEnableDevice),
                    Text(descEnableDevice, textAlign: TextAlign.center),
                  ]);
                }
                return Column(
                    children: snapshot.data!.map((ScanResult result) {
                  return DeviceTile(device: result.device);
                }).toList());
              },
            );
          }
          return Column(
              children: snapshot.data!.map((BluetoothDevice device) {
            return DeviceTile(device: device);
          }).toList());
        },
      ),
    ]);
  }
}
