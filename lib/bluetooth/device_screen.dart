import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'tiles/characteristic_tile.dart';

class DeviceScreen extends StatelessWidget {
  DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothService>>(
      stream: device.services,
      builder: (BuildContext context, AsyncSnapshot<List<BluetoothService>> services) {
        BluetoothService service =
            services.data.singleWhere((s) => s.uuid.toString() == "7e4e1701-1ea6-40c9-9dcc-13d34ffead57");
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...service.characteristics.map(
              (c) => CharacteristicTile(
                characteristic: c,
                onRead: () async => await c.read(),
                onWrite: () async => await c.write([100]),
                onNotify: () async => await c.setNotifyValue(!c.isNotifying),
              ),
            ),
          ],
        );
      },
    );
  }
}
