import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/text_styles.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
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
        if (snapshot.hasData && snapshot.data!) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              onLongPress: () => disconnectDevice().then(context.pop),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(deviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Long press to disconnect', style: TextStyle(fontSize: 12, color: colorRed400)),
              leading: const CustomButton(
                radius: 25,
                color: colorGoogleGreen,
                icon: Icon(Icons.bluetooth_connected_rounded, size: 30),
              ),
            ),
            StreamBuilder<ChartData>(
              initialData: ChartData(),
              stream: graphDataStream,
              builder: (_, AsyncSnapshot<ChartData> snapshot) => Text('${snapshot.data!.load} Kg.', style: tsG40B),
            ),
            const Text(
              descTareProgressor,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            CustomButton(
              onPressed: () async => stopTaring().then(context.pop),
              icon: const Icon(Icons.adjust),
              child: const Text('Tare Progressor'),
            ),
          ]);
        } else {
          return const CustomProgress();
        }
      },
    );
  }
}
