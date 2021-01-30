import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/Components.dart';

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
  BluetoothCharacteristic _mControlCharacteristic;

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
        backgroundColor: Colors.black,
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
      timeout: Duration(seconds: 5),
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
              // StreamBuilder<List<BluetoothDevice>>(
              //   stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
              //   builder: (_, snapshot) {
              //       return Column(
              //         children: snapshot.data.map((device) {
              //           return Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               ListTile(
              //                 title: Text(device.name),
              //                 subtitle: Text('Click to Tare'),
              //                 onTap: () async => await _mControlCharacteristic.write([100]),
              //               ),
              //               ListTile(
              //                 title: Text('Start Measuring'),
              //                 onTap: () async => await _mControlCharacteristic.write([101]),
              //               ),
              //               ListTile(
              //                 title: Text('Stop Measuring'),
              //                 onTap: () async => await _mControlCharacteristic.write([102]),
              //               ),
              //               ListTile(
              //                 title: Text('Start Notification'),
              //                 onTap: () async =>
              //                     await _mDataCharacteristic.setNotifyValue(!_mDataCharacteristic.isNotifying),
              //               ),
              //               ListTile(
              //                 title: Text('Disconnect'),
              //                 onTap: () async => await device.disconnect(),
              //               ),
              //               ListTile(
              //                 title: Text('Sleep'),
              //                 onTap: () async => await _mControlCharacteristic.write([110]),
              //               ),
              //             ],
              //           );
              //         }).toList(),
              //       );
              //   },
              // ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                builder: (_, snapshot) {
                  if (snapshot.data.length > 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: snapshot.data.map((r) {
                        return FlatButton.icon(
                          onPressed: () => _connect(r.device),
                          icon: Icon(Icons.bluetooth_rounded, color: Colors.white),
                          label: Text(r.device.name, style: TextStyle(color: Colors.white)),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                        );
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

  void _connect(BluetoothDevice device) async {
    await device.connect();
    await device
        .discoverServices()
        .then((services) {
          return services.singleWhere((service) => service.uuid.toString() == _SERVICE_UUID);
        })
        .then((service) => service.characteristics)
        .then((characteristics) {
          return characteristics.forEach((characteristic) {
            if (characteristic.uuid.toString() == _DATA_CHARACTERISTIC_UUID) {
              _mDataCharacteristic = characteristic;
              _mDataCharacteristic.value.listen(print);
            } else if (characteristic.uuid.toString() == _CONTROL_POINT_UUID) {
              _mControlCharacteristic = characteristic;
            }
          });
        });
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
