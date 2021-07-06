import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/device/device_tile.dart';
import 'package:tendon_loader/handler/device_handler.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: const <ScanResult>[],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) {
        if (snapshot.data!.isEmpty) return const _EnableDeviceTile();
        return Column(
          children: snapshot.data!.map((ScanResult result) {
            final BluetoothDevice _device = result.device;
            return DeviceTile(device: _device, deviceName: _device.name.isEmpty ? _device.id.id : _device.name);
          }).toList(),
        );
      },
    );
  }
}

class _EnableDeviceTile extends StatelessWidget {
  const _EnableDeviceTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
      CustomImage(name: imgEnableDevice),
      Text(descEnableBluetooth, textAlign: TextAlign.center),
      SizedBox(height: 30),
      CustomButton(
        icon: Icon(Icons.search_rounded),
        onPressed: startDeviceScan,
        child: Text('Scan'),
      ),
    ]);
  }
}
