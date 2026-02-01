import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/utils/constants.dart';

/// After successful connection to the "Progressor", the app will present user
/// with "Taring" (essentially zero-ing or reseting) the "Progressor"
/// to read acurate data. By the time and excessive use of the "Progressor" will
/// produce some garbage data, which causes in-accuracy in the data measured.
/// The "Taring" process is vary strait-forward, just make your connected
/// "Progressor" (either by squeezing or pulling), to sat down at "0 Kg.",
/// keep holding, and click the "Tare Progressor" button.
@immutable
class ConnectedTile extends StatelessWidget {
  const ConnectedTile({super.key, required this.device});

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) => FutureBuilder(
    initialData: false,
    future: Progressor.instance.init(device: device),
    builder: (context, snapshot) {
      if (!snapshot.requireData) {
        return const ButtonFactory.loading();
      }
      return Column(
        mainAxisSize: .min,
        children: [
          ListTile(
            onLongPress: Progressor.instance.disconnect,
            contentPadding: const .all(5),
            shape: RoundedRectangleBorder(borderRadius: .circular(16)),
            title: Text(
              Progressor.instance.deviceName,
              style: const TextStyle(fontWeight: .bold),
            ),
            subtitle: const Text(
              'Long press to disconnect',
              style: TextStyle(fontSize: 12, color: Color(0xffff534d)),
            ),
            leading: const ButtonFactory(
              color: Color(0xff3ddc85),
              child: Icon(Icons.bluetooth_connected, color: Color(0xffffffff)),
            ),
          ),
          StreamBuilder(
            initialData: const ChartData(),
            stream: GraphHandler.stream,
            builder: (_, snapshot) => Text(
              '${snapshot.data!.load.toStringAsFixed(1)} Kg.',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: .bold,
                color: Color(0xff3ddc85),
              ),
            ),
          ),
          const Text(
            Strings.tareProgressor,
            textAlign: .center,
            style: TextStyle(fontSize: 14, fontWeight: .w500),
          ),
          ButtonFactory.tile(
            leading: const Icon(Icons.adjust),
            child: const Text('Tare Progressor'),
            onTap: () async {
              await Progressor.instance.tare();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}
