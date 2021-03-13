import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class Device extends StatelessWidget {
  const Device({@required this.state});

  final BluetoothDeviceState state;

  @override
  Widget build(BuildContext context) {
    if (state == BluetoothDeviceState.connected) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Device is connected successfully and ready to use!\nClick on the device name to disconnect.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomButton(
            color: Colors.green[700],
            text: Bluetooth.device.name,
            icon: Icons.bluetooth_connected_rounded,
            onPressed: () async => await Bluetooth.instance.disconnect(),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Close',
            icon: Icons.cancel,
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Click on the device name to connect\n Note: this might take a moment to connect.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: Bluetooth.device.name,
            icon: Icons.bluetooth_rounded,
            color: Colors.deepOrange[700],
            onPressed: () async => await Bluetooth.instance.connect(),
          ),
        ],
      );
    }
  }
}
