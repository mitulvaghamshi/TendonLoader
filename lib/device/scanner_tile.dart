import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/device/device_list.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';

class ScannerTile extends StatelessWidget {
  const ScannerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return Column(children: <Widget>[
          const DeviceList(),
          const SizedBox(height: 10),
          if (snapshot.data!)
            Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
              CustomProgress(text: 'Scanning...'),
              CustomButton(
                text: Text('Stop'),
                icon: Icon(Icons.close_rounded),
                onPressed: stopDeviceScan,
              ),
            ])
          else
            const CustomButton(
              text: Text('Scan'),
              icon: Icon(Icons.search_rounded),
              onPressed: startDeviceScan,
            ),
        ]);
      },
    );
  }
}
