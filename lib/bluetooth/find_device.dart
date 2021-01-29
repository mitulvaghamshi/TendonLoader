import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/device_screen.dart';

import '../bluetooth/tiles/scan_result_tile.dart';

class FindDevices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search_rounded),
        title: Text('Find Bluetooth Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: _startScan,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (_, snapshot) {
                  return Column(
                    children: snapshot.data.map(
                      (device) {
                        return ListTile(
                          title: Text(device.name),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => DeviceScreen(device: device)),
                            );
                          },
                        );
                      },
                    ).toList(),
                  );
                },
              ),
              ExpansionTile(
                title: Text('New Devices'),
                children: [
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (_, snapshot) {
                      return Column(
                        children: snapshot.data.map(
                          (r) {
                            return ScanResultTile(
                              result: r,
                              onTap: () {
                                r.device.connect();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => DeviceScreen(device: r.device)),
                                );
                              },
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton.extended(
              label: const Text('Stop'),
              icon: Icon(Icons.search_off_rounded),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton.extended(
              label: const Text('Scan'),
              icon: Icon(Icons.search_rounded),
              onPressed: _startScan,
            );
          }
        },
      ),
    );
  }

  Future<void> _startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: Duration(seconds: 5),
      withDevices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
      withServices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
    );
  }
}
