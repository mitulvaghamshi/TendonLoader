import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocation/geolocation.dart';
import 'package:tendon_loader/components/bluetooth.dart';
import 'package:tendon_loader/components/flat_icon_button.dart';

class DeviceScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDeviceScanner();
  }

  StreamBuilder<BluetoothState> _buildDeviceScanner() {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (_, snapshot) {
        if (snapshot.data == BluetoothState.on) {
          return _scanResult();
        } else {
          return _enableBluetooth();
        }
      },
    );
  }

  StreamBuilder<List<ScanResult>> _scanResult() {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: [],
      builder: (_, snapshot) {
        if (snapshot.data.isNotEmpty) {
          return _selectDevice(snapshot);
        } else {
          return _enableScanning();
        }
      },
    );
  }

  StreamBuilder<bool> _enableScanning() {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data) {
          return _stopScanning();
        } else {
          return _startScanning();
        }
      },
    );
  }

  StreamBuilder<bool> _startScanning() {
    final StreamController<bool> _locationStateController = StreamController<bool>();
    return StreamBuilder<bool>(
      stream: _locationStateController.stream,
      initialData: true,
      builder: (_, snapshot) {
        if (snapshot.data) {
          return _activateDevice(_locationStateController);
        } else {
          return _enableLocation(_locationStateController);
        }
      },
    );
  }

  Column _selectDevice(AsyncSnapshot<List<ScanResult>> snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...snapshot.data.map((r) {
          Bluetooth.instance.setDevice(r.device);
          return StreamBuilder<BluetoothDeviceState>(
            stream: r.device.state,
            builder: (_, snapshot) {
              if (snapshot.data == BluetoothDeviceState.connected) {
                return FlatIconButton(
                  r.device.name,
                  icon: Icons.bluetooth_connected_rounded,
                  color: Colors.green[700],
                  callBack: () async => await Bluetooth.instance.disconnect(),
                );
              } else {
                return FlatIconButton(
                  r.device.name,
                  icon: Icons.bluetooth_rounded,
                  color: Colors.deepOrange[700],
                  callBack: () async => await Bluetooth.instance.connect(),
                );
              }
            },
          );
        }),
      ],
    );
  }

  Column _stopScanning() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(),
            Text('Please wait...', style: TextStyle(fontSize: 20.0)),
          ],
        ),
        SizedBox(height: 30),
        FlatIconButton(
          'Stop',
          icon: Icons.close_rounded,
          color: Colors.deepOrangeAccent,
          callBack: () async => Bluetooth.instance.stopScan(),
        ),
      ],
    );
  }

  Column _activateDevice(StreamController<bool> _locationStateController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/enable_device.webp', width: 180),
        Text(
          'Activate your device by pressing the button, then press scan to find the device',
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        SizedBox(height: 30),
        FlatIconButton(
          'Scan',
          icon: Icons.search_rounded,
          color: Colors.black,
          callBack: () async {
            await Geolocation.isLocationOperational().then((value) async {
              if (value.isSuccessful) {
                await Bluetooth.instance.startScan();
                if (!_locationStateController.isClosed) _locationStateController.close();
              } else {
                _locationStateController.add(value.isSuccessful);
              }
            });
          },
        ),
      ],
    );
  }

  Column _enableLocation(StreamController<bool> _locationStateController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/enable_location.webp', width: 180),
        Text(
          'This app uses bluetooth to communicate with your Progressor.',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          'Scanning for bluetooth devices can be used to locate you. That\'s why we ask you to permit location services. We\'re only using this permission to scan for your Progressor.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Text(
          'We\'ll never collect your physical location.',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        FlatIconButton(
          'Enable',
          icon: Icons.location_on_rounded,
          color: Colors.black,
          callBack: () async {
            await Geolocation.enableLocationServices().then((value) {
              _locationStateController.add(value.isSuccessful);
            });
          },
        ),
      ],
    );
  }

  Column _enableBluetooth() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/enable_bluetooth.webp', width: 180),
        Text(
          'This app needs Bluetooth to communicate with your Progressor. Please enable Bluetooth on your device.',
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        FlatIconButton(
          'Enable',
          icon: Icons.bluetooth_rounded,
          color: Colors.black,
          callBack: () async => await Bluetooth.instance.enable(),
        ),
      ],
    );
  }
}
