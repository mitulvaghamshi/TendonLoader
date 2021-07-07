import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/device/tiles/scanner_tile.dart';

class LocationTile extends StatefulWidget {
  const LocationTile({Key? key}) : super(key: key);

  @override
  _LocationTileState createState() => _LocationTileState();
}

class _LocationTileState extends State<LocationTile> {
  final BehaviorSubject<bool> _controller = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      final bool _enabled = await Location.instance.serviceEnabled();
      if (!_controller.isClosed) _controller.sink.add(_enabled);
      return Future<bool>.delayed(const Duration(seconds: 2), () => !_enabled);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (!_controller.isClosed) _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _controller.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) return const ScannerTile();
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
