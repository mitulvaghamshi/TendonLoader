import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircularProgressIndicator(),
            const Text('Please wait...', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Stop',
          icon: Icons.close_rounded,
          color: Colors.deepOrangeAccent,
          onPressed: () async => Bluetooth.instance.stopScan(),
        ),
      ],
    );
  }
}
