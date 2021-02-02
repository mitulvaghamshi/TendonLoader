import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/Components.dart';

import 'bluetooth/bluetooth_args.dart';
import 'screens/exercise_mode.dart';
import 'screens/extras/logo.dart';
import 'screens/live_data.dart';
import 'screens/mvic_testing.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _serviceUuid = "7e4e1701-1ea6-40c9-9dcc-13d34ffead57"; // main service
  final _dataCharacteristicUuid = "7e4e1702-1ea6-40c9-9dcc-13d34ffead57"; // receive data
  final _controlPointUuid = "7e4e1703-1ea6-40c9-9dcc-13d34ffead57"; // send commands

  bool _connectionState = false;

  BluetoothDevice _device;
  BluetoothCharacteristic _mDataCharacteristic;
  BluetoothCharacteristic _mControlCharacteristic;

  BluetoothArgs args;

  @override
  void initState() {
    super.initState();
    args = BluetoothArgs(
      device: _device,
      mDataCharacteristic: _mDataCharacteristic,
      mControlCharacteristic: _mControlCharacteristic,
    );
  }

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
                _buildListTile(context, LiveData.name, LiveData.routeName, Icons.show_chart_rounded),
                const SizedBox(height: 10.0),
                _buildListTile(context, ExerciseMode.name, ExerciseMode.routeName, Icons.directions_run_rounded),
                const SizedBox(height: 10.0),
                _buildListTile(context, MVICTesting.name, MVICTesting.routeName, Icons.airline_seat_legroom_extra),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: Stream.value(_connectionState),
        builder: (context, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton.extended(
              label: Text('Device Connected'),
              backgroundColor: Colors.green,
              icon: Icon(Icons.check),
              onPressed: () => _findDevice(context),
            );
          } else {
            return FloatingActionButton.extended(
              label: Text('Connect Device'),
              backgroundColor: Colors.black,
              icon: Icon(Icons.bluetooth_rounded),
              onPressed: () => _findDevice(context),
            );
          }
        },
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String name, String route, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: Icon(icon, size: 30.0),
      onTap: () => Navigator.of(context).pushNamed(route, arguments: args),
      title: Text(name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                builder: (_, snapshot) {
                  if (snapshot.data.length > 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: snapshot.data.map((r) {
                        _device = r.device;
                        return StreamBuilder<BluetoothDeviceState>(
                            stream: r.device.state,
                            builder: (_, snapshot) {
                              if (snapshot.data == BluetoothDeviceState.connected) {
                                return FlatButtonIcon(
                                  r.device.name,
                                  icon: Icons.bluetooth_connected_rounded,
                                  color: Colors.green[400],
                                  callBack: () async {
                                    await r.device.disconnect();
                                    _connectionState = false;
                                  },
                                );
                              } else if (snapshot.data == BluetoothDeviceState.disconnected) {
                                return FlatButtonIcon(
                                  r.device.name,
                                  icon: Icons.bluetooth_rounded,
                                  color: Colors.deepOrange[400],
                                  callBack: () async {
                                    await _connectTo(r.device);
                                    _connectionState = true;
                                  },
                                );
                              } else {
                                return LinearProgressIndicator(minHeight: 10);
                              }
                            });
                      }).toList(),
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/enable_device.webp', width: 180),
                        Text(
                          'Activate your device by pressing the button, then press scan to find the device',
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    );
                  }
                },
              ),
              StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data) {
                    return FlatButtonIcon(
                      'Stop',
                      icon: Icons.close_rounded,
                      color: Colors.deepOrangeAccent,
                      callBack: () async => await FlutterBlue.instance.stopScan(),
                    );
                  } else {
                    return FlatButtonIcon(
                      'Scan',
                      icon: Icons.search_rounded,
                      color: Colors.black,
                      callBack: () async => await _startScan(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: Duration(seconds: 5),
      withDevices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
      withServices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
    );
  }

  Future<void> _connectTo(BluetoothDevice device) async {
    await device.connect();
    await device.discoverServices().then((services) {
      return services.singleWhere((service) {
        return service.uuid.toString() == _serviceUuid;
      });
    }).then((service) {
      return service.characteristics;
    }).then((characteristics) {
      return characteristics.forEach((characteristic) {
        if (characteristic.uuid.toString() == _dataCharacteristicUuid) {
          _mDataCharacteristic = characteristic;
        } else if (characteristic.uuid.toString() == _controlPointUuid) {
          _mControlCharacteristic = characteristic;
        }
      });
    });
  }
}
