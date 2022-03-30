import 'package:flutter/material.dart';
import 'package:tendon_loader/app/bluetooth/bluetooth_handler.dart';
import 'package:tendon_loader/app/bluetooth/widgets/image_widget.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

class StartScanTile extends StatelessWidget {
  const StartScanTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
      ImageWidget(name: imgEnableDevice),
      Text(
        descEnableDevice,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      ButtonWidget(
        onPressed: startScan,
        size: MainAxisSize.max,
        left: Icon(Icons.search),
        right: Text('Scan'),
      ),
    ]);
  }
}
