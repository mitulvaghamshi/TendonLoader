import 'package:flutter/material.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';

class DebugBT extends StatefulWidget {
  const DebugBT({Key? key}) : super(key: key);

  static const String route = '/debug';

  @override
  _DebugBTState createState() => _DebugBTState();
}

class _DebugBTState extends State<DebugBT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(deviceName)),
      body: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: graphDataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              return Text(
                'Time: ${snapshot.data!.time} Weight: ${snapshot.data!.load}',
                style: const TextStyle(fontSize: 30),
              );
            },
          ),
          StreamBuilder<int>(
            initialData: -1,
            stream: device.mtu,
            builder: (_, AsyncSnapshot<int> snapshot) {
              return Text('MTU: ${snapshot.data}', style: const TextStyle(fontSize: 30));
            },
          ),
          const SizedBox(height: 30),
          ListTile(onTap: () async => device.requestMtu(120), title: const Text('request MTU: 120')),
          ListTile(onTap: () async => tareDevice(), title: const Text('100: tare scale')),
          ListTile(onTap: () async => startWeightMeasuring(), title: const Text('101: start weight meas')),
          ListTile(onTap: () async => stopWeightMeasuring(), title: const Text('102: stop weight meas')),
          ListTile(onTap: () async => disconnectDevice(), title: const Text('disconnect')),
        ],
      ),
    );
  }
}
