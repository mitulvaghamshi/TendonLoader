import 'package:flutter/material.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';

class StopScanTile extends StatelessWidget {
  const StopScanTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            CircularProgressIndicator(),
            Text('Please wait...', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 30),
        const CustomButton(text: 'Stop', icon: Icons.close_rounded, onPressed: Bluetooth.stopScan),
      ],
    );
  }
}
