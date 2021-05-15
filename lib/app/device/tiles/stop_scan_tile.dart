import 'package:flutter/material.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_progress.dart';

class StopScanTile extends StatelessWidget {
  const StopScanTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomProgress(),
        SizedBox(height: 30),
        CustomButton(
            text: 'Stop',
            icon: Icons.close_rounded,
            onPressed: Bluetooth.stopScan),
      ],
    );
  }
}
