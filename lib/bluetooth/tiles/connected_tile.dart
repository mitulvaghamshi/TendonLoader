import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class ConnectedTile extends StatelessWidget {
  const ConnectedTile({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getProps(device),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData || !snapshot.data!) return const CustomProgress();
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            onLongPress: disconnectDevice,
            contentPadding: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(deviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Long press to disconnect', style: TextStyle(fontSize: 12, color: colorRed400)),
            leading: const CustomButton(
              color: colorGoogleGreen,
              left: Icon(Icons.bluetooth_connected, color: colorWhite, size: 30),
            ),
          ),
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: GraphHandler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              return Text('${snapshot.data!.load.toStringAsFixed(1)} Kg.', style: tsG40B);
            },
          ),
          const Text(
            descTareProgressor,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          CustomButton(
            left: const Icon(Icons.adjust),
            right: const Text('Tare Progressor'),
            onPressed: () async => tareProgressor().then(context.pop),
          ),
        ]);
      },
    );
  }
}
