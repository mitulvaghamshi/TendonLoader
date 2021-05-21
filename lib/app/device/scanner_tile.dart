import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/device/device_list.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_progress.dart';

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
