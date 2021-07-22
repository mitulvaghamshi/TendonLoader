import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/utils/constant/descriptions.dart';
import 'package:tendon_loader/utils/constant/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/screens/device/tiles/progressor_tile.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: Stream<bool?>.periodic(const Duration(seconds: 1)).asyncMap((_) => Location.instance.serviceEnabled()),
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.hasData && snapshot.data!) return const ProgressorTile();
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
            onPressed: AppSettings.openLocationSettings,
            icon: Icon(Icons.location_on_rounded),
            child: Text('Open Settings'),
          ),
        ]);
      },
    );
  }
}
