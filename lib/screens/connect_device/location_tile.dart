import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/connect_device/enable_location_tile.dart';
import 'package:tendon_loader/screens/connect_device/scan_result_tile.dart';
import 'package:tendon_loader/utils/controller/location.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Locator.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data ? const ScanResultTile() : const EnableLocationTile(),
    );
  }
}
