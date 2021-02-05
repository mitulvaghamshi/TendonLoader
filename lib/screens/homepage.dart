import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/bluetooth.dart';

import '../components/app_logo.dart';
import '../utils//bluetooth_args.dart';
import 'exercise_mode.dart';
import 'live_data.dart';
import 'mvic_testing.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  static const name = 'Tendon Loader';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _serviceUuid = "7e4e1701-1ea6-40c9-9dcc-13d34ffead57"; // main service
  final _dataCharacteristicUuid = "7e4e1702-1ea6-40c9-9dcc-13d34ffead57"; // receive data
  final _controlPointUuid = "7e4e1703-1ea6-40c9-9dcc-13d34ffead57"; // send commands

  BluetoothDevice _device;
  BluetoothCharacteristic _mDataCharacteristic;
  BluetoothCharacteristic _mControlCharacteristic;

  @override
  void dispose() {
    FlutterBlue.instance.connectedDevices.then((devices) => devices.forEach((d) => d.disconnect()));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(HomePage.name), centerTitle: true),
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Connect Device'),
        icon: Icon(Icons.bluetooth_rounded),
        onPressed: () => _findDevice(context),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String name, String route, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 30.0),
      contentPadding: const EdgeInsets.all(16.0),
      trailing: Icon(Icons.keyboard_arrow_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onTap: () {
        BluetoothArgs _btArgs = BluetoothArgs(
          device: _device,
          mDataCharacteristic: _mDataCharacteristic,
          mControlCharacteristic: _mControlCharacteristic,
        );
        Navigator.of(context).pushNamed(route, arguments: _btArgs);
      },
      title: Text(name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
  }

  void _findDevice(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text('Select Bluetooth Device', textAlign: TextAlign.center),
          content: Bluetooth(onConnect: _connectTo),
        );
      },
    );
  }

  Future<void> _connectTo(BluetoothDevice device) async {
    _device = device;
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
