/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:app_settings/app_settings.dart' as ast;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/bluetooth/tiles/start_scan_tile.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/utils/constants.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: Stream<bool?>.periodic(const Duration(milliseconds: 500))
          .asyncMap((_) async => Location.instance.serviceEnabled()),
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.hasData && snapshot.data!) return const StartScanTile();
        return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          CustomImage(name: imgEnableLocation),
          Text(
            descLocationLine1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            descLocationLine3,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          CustomButton(
            onPressed: ast.AppSettings.openLocationSettings,
            left: Icon(Icons.location_on_rounded),
            right: Text('Open Settings'),
          ),
        ]);
      },
    );
  }
}
