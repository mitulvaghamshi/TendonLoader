import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/device/device_tile.dart';
import 'package:tendon_loader/handlers/device_handler.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      // initialData: const <ScanResult>[],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
              children: snapshot.data!.map((ScanResult result) {
            return DeviceTile(device: result.device);
          }).toList());
        } else {
          return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
            CustomImage(name: imgEnableDevice),
            Text(
              descEnableDevice,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            CustomButton(icon: Icon(Icons.search), onPressed: startDeviceScan, child: Text('Scan')),
          ]);
        }
      },
    );
  }
}
