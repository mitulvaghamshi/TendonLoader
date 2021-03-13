import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class EnableBluetooth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomImage(name: 'enable_bluetooth.webp'),
        const Text(
          'This app needs Bluetooth to communicate with your Progressor. Please enable Bluetooth on your device.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Enable',
          color: Colors.black,
          icon: Icons.bluetooth_rounded,
          onPressed: () async => await Bluetooth.instance.enable(),
        ),
      ],
    );
  }
}
