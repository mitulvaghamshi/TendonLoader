import 'package:app_settings/app_settings.dart' as ast;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/widgets/image_widget.dart';
import 'package:tendon_loader/app/bluetooth/widgets/location_tile.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      builder: (_, AsyncSnapshot<BluetoothState> snapshot) {
        if (snapshot.hasData && snapshot.data == BluetoothState.on) {
          return const LocationTile();
        }
        return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          ImageWidget(name: imgEnableBluetooth),
          Text(
            descEnableBluetooth,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          ButtonWidget(
            size: MainAxisSize.max,
            left: Icon(Icons.bluetooth),
            right: Text('Open Settings'),
            onPressed: ast.AppSettings.openBluetoothSettings,
          ),
        ]);
      },
    );
  }
}
