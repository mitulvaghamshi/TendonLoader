import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'screens/extras/logo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _SERVICE_UUID = "7e4e1701-1ea6-40c9-9dcc-13d34ffead57"; // main service
  final _DATA_CHARACTERISTIC_UUID = "7e4e1702-1ea6-40c9-9dcc-13d34ffead57"; // receive data
  final _CONTROL_POINT_UUID = "7e4e1703-1ea6-40c9-9dcc-13d34ffead57"; // send commands

  BluetoothCharacteristic _mDataCharacteristic;
  BluetoothCharacteristic _mNotifyCharacteristic;

  @override
  void dispose() {
    FlutterBlue.instance.connectedDevices.then((devices) => devices.forEach((d) => d.disconnect()));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: SingleChildScrollView(
        child: Card(
          elevation: 16.0,
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Logo(),
                const SizedBox(height: 10.0),
                _createTile('Live Data', Icons.show_chart),
                const SizedBox(height: 10.0),
                _createTile('Exercise Mode', Icons.directions_run),
                const SizedBox(height: 10.0),
                _createTile('MVIC Testing', Icons.airline_seat_legroom_extra),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Connect Device'),
        backgroundColor: Colors.deepOrange,
        icon: Icon(Icons.bluetooth_rounded),
        onPressed: () => _findDevice(context),
      ),
    );
  }

  ListTile _createTile(String text, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: Icon(icon, size: 30.0),
      onTap: () => Navigator.of(context).pushNamed(text),
      title: Text(text, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
  }

  Future<void> _startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: Duration(seconds: 10),
      withDevices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
      withServices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
    );
  }

  void _findDevice(BuildContext context) async {
    await showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Select Bluetooth Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data) {
                    return ListTile(
                      title: Text('Stop Scanning...'),
                      leading: Icon(Icons.search_off_rounded),
                      tileColor: Colors.blue,
                      onTap: () => FlutterBlue.instance.stopScan(),
                    );
                  } else {
                    return ListTile(
                      title: Text('Start Scanning'),
                      leading: Icon(Icons.search_rounded),
                      tileColor: Colors.blue,
                      onTap: () async => await _startScan(),
                    );
                  }
                },
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (_, snapshot) {
                  return Column(
                    children: snapshot.data.map((device) {
                      return ListTile(
                        title: Text(device.name),
                        subtitle: Text('Click to Tare'),
                        tileColor: Colors.green,
                        leading: Icon(Icons.bluetooth_connected_rounded),
                        onTap: () async => await device.disconnect(),
                      );
                    }).toList(),
                  );
                },
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (_, snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: snapshot.data.map((r) {
                      return ListTile(
                        title: Text(r.device.name),
                        subtitle: Text('Click to Connect'),
                        leading: Icon(Icons.bluetooth_rounded),
                        tileColor: Colors.orangeAccent,
                        onTap: () async => await r.device.connect(),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
/*StreamBuilder<List<ScanResult>>(
stream: FlutterBlue.instance.scanResults,
    builder: (_, snapshot) {
    ScanResult result = snapshot.data.first;
    result.device.discoverServices();

    return StreamBuilder<BluetoothDeviceState>(
    stream: result.device.state,
    builder: (_, snapshot) {
    */ /* BluetoothService _service;
    if (snapshot.data == BluetoothDeviceState.connected) {*/ /*
        // result.device.discoverServices();
        return StreamBuilder<List<BluetoothService>>(
        stream: result.device.services,
        builder: (_, snapshot) {

        return ExpansionTile(
        title: Text(_service.uuid.toString(), overflow: TextOverflow.ellipsis),
        children: [
        StreamBuilder<List<BluetoothCharacteristic>>(
        stream: Stream.value(_service.characteristics),
        builder: (_, snapshot) {
        return Column(
        children: snapshot.data.map((c) {
        print(c.uuid.toString());
        if (c.uuid.toString() == _DATA_CHARACTERISTIC_UUID) {
        } else if (c.uuid.toString() == _CONTROL_POINT_UUID) {
        }
        return CharacteristicTile(
        characteristic: c,
        onRead: () => c.read(),
        onWrite: () => c.write([100]),
        onNotify: () => c.setNotifyValue(!c.isNotifying),
        );
        }).toList(),
        );
        },
        ),
        ],
        );
        }
        );
        } else {
        return ListTile(
        title: Text(result.device.name, overflow: TextOverflow.ellipsis),
        onTap: () async {
        await result.device.connect();
        _service = await result.device.discoverServices().then((services) {
        return services.singleWhere((s) => s.uuid.toString() == _SERVICE_UUID);
        });
        },
        );
        }
        },
        );
        */ /*} else {
                return LinearProgressIndicator(minHeight: 10);
              }*/ /*
      },
    )
    ,*/
