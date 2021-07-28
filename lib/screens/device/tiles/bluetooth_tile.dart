import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/utils/descriptions.dart';
import 'package:tendon_loader/utils/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/screens/device/tiles/location_tile.dart';

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      builder: (_, AsyncSnapshot<BluetoothState> snapshot) {
        if (snapshot.hasData && snapshot.data == BluetoothState.on) return const LocationTile();
        return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          CustomImage(name: imgEnableBluetooth),
          Text(
            descEnableBluetooth,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          CustomButton(
            onPressed: AppSettings.openBluetoothSettings,
            left: Icon(Icons.bluetooth),
            right: Text('Open Settings'),
          ),
        ]);
      },
    );
  }
}
