import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/bluetooth_handler.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

class ConnectedTile extends StatelessWidget {
  const ConnectedTile({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getProps(device),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData || !snapshot.data!) {
          return const CustomTile(
            title: 'Please wait...',
            left: CircularProgressIndicator.adaptive(),
          );
        }
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            onLongPress: disconnectDevice,
            contentPadding: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              deviceName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Long press to disconnect',
              style: TextStyle(fontSize: 12, color: Color(0xffff534d)),
            ),
            leading: const ButtonWidget(
              color: Color(0xff3ddc85),
              left: Icon(
                Icons.bluetooth_connected,
                color: Color(0xffffffff),
              ),
            ),
          ),
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: GraphHandler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) => Text(
              '${snapshot.data!.load.toStringAsFixed(1)} Kg.',
              style: const TextStyle(
                fontSize: 40,
                color: Color(0xff3ddc85),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            descTareProgressor,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          ButtonWidget(
            left: const Icon(Icons.adjust),
            right: const Text('Tare Progressor'),
            onPressed: () async => tareProgressor().then(context.pop),
          ),
        ]);
      },
    );
  }
}
