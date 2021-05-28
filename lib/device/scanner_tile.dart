import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' show FlutterBlue;
import 'package:tendon_loader/device/device_list.dart' show DeviceList;
import 'package:tendon_loader/handler/bluetooth_handler.dart' show Bluetooth;
import 'package:tendon_support_lib/tendon_support_lib.dart' show CustomButton, CustomProgress;

class ScannerTile extends StatelessWidget {
  const ScannerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return Column(
          children: <Widget>[
            const DeviceList(),
            const SizedBox(height: 10),
            if (snapshot.data!)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  CustomProgress(text: 'Scanning...'),
                  CustomButton(text: 'Stop', icon: Icons.close_rounded, onPressed: Bluetooth.stopScan),
                ],
              )
            else
              const CustomButton(text: 'Scan', icon: Icons.search_rounded, onPressed: Bluetooth.startScan),
          ],
        );
      },
    );
  }
}
