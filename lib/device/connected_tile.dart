import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/handler/device_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/themes.dart';

class ConnectedTile extends StatelessWidget {
  const ConnectedTile({Key? key, required this.device, required this.deviceName}) : super(key: key);

  final String deviceName;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getProps(device),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              onLongPress: disconnectDevice,
              contentPadding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(deviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Long press to disconnect', style: TextStyle(fontSize: 12)),
              leading: CustomButton(
                radius: 25,
                color: colorGoogleGreen,
                onPressed: () {},
                icon: const Icon(Icons.bluetooth_connected_rounded, size: 30),
              ),
            ),
            StreamBuilder<ChartData>(
              initialData: ChartData(),
              stream: graphDataStream,
              builder: (_, AsyncSnapshot<ChartData> snapshot) => Text(
                '${snapshot.data!.load} Kg.',
                style: const TextStyle(color: colorGoogleGreen, fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              descTareProgressor,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            CustomButton(
              onPressed: () => stopTaring().then((_) => Navigator.pop(context)),
              icon: const Icon(Icons.adjust),
              child: const Text('Tare Progressor'),
            ),
          ]);
        } else {
          return const CustomProgress(text: 'Connecting...');
        }
      },
    );
  }
}
