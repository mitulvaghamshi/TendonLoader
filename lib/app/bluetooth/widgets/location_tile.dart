import 'package:app_settings/app_settings.dart' as ast;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/app/bluetooth/widgets/image_widget.dart';
import 'package:tendon_loader/app/bluetooth/widgets/start_scan_tile.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: Stream<bool?>.periodic(const Duration(milliseconds: 500))
          .asyncMap((_) async => Location.instance.serviceEnabled()),
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.hasData && snapshot.data!) return const StartScanTile();
        return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          ImageWidget(name: imgEnableLocation),
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
          ButtonWidget(
            onPressed: ast.AppSettings.openLocationSettings,
            left: Icon(Icons.location_on_rounded),
            right: Text('Open Settings'),
            size: MainAxisSize.max,
          ),
        ]);
      },
    );
  }
}
