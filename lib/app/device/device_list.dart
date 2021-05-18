import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/device/device_tile.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<BluetoothDevice>>(
          initialData: const <BluetoothDevice>[],
          stream: Stream<List<BluetoothDevice>>.fromFuture(FlutterBlue.instance.connectedDevices),
          builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
            if (snapshot.data.isEmpty)
              return StreamBuilder<List<ScanResult>>(
                initialData: const <ScanResult>[],
                stream: FlutterBlue.instance.scanResults,
                builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) {
                  if (snapshot.data.isEmpty)
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        CustomImage(name: Images.IMG_ENABLE_DEVICE),
                        Text(Descriptions.DESC_ENABLE_DEVICE),
                      ],
                    );
                  return Column(
                    children: snapshot.data.map((ScanResult result) => DeviceTile(device: result.device)).toList(),
                  );
                },
              );
            return Column(
              children: snapshot.data.map((BluetoothDevice device) => DeviceTile(device: device)).toList(),
            );
          },
        ),
      ],
    );
  }
}
