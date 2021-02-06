import 'dart:async';

import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocation/geolocation.dart';
import 'package:tendon_loader/components/flat_icon_button.dart';

class Bluetooth extends StatelessWidget {
  final Function onConnect;

  Bluetooth({Key key, this.onConnect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (_, snapshot) {
            if (snapshot.data == BluetoothState.on) {
              return _enableLocationTile();
            } else {
              return _enableBluetoothTile();
            }
          },
        ),
      ],
    );
  }

  Column _enableBluetoothTile() {
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
          callBack: () async => await BluetoothEnable.enableBluetooth,
        ),
      ],
    );
  }

  StreamBuilder<bool> _enableLocationTile() {
    StreamController<bool> _controller = StreamController<bool>();
    Geolocation.isLocationOperational().then((value) => _controller.add(value.isSuccessful));
    return StreamBuilder<bool>(
      stream: _controller.stream,
      initialData: false,
      builder: (_, snapshot) {
        if (!snapshot.data) {
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
                    if (value.isSuccessful) _controller.add(true);
                  });
                },
              ),
            ],
          );
        } else {
          if (!_controller.isClosed) _controller.close();
          return _selectDeviceTile();
        }
      },
    );
  }

  Column _selectDeviceTile() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<List<ScanResult>>(
          stream: FlutterBlue.instance.scanResults,
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return _scanResultTile(snapshot);
            } else {
              return _startScanningTile();
            }
          },
        ),
      ],
    );
  }

  Column _startScanningTile() {
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
        StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FlatIconButton(
                'Stop',
                icon: Icons.close_rounded,
                color: Colors.deepOrangeAccent,
                callBack: () async => await FlutterBlue.instance.stopScan(),
              );
            } else {
              return FlatIconButton(
                'Scan',
                icon: Icons.search_rounded,
                color: Colors.black,
                callBack: () async => await _startScan(),
              );
            }
          },
        ),
      ],
    );
  }

  Column _scanResultTile(AsyncSnapshot<List<ScanResult>> snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder<List<BluetoothDevice>>(
          stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
          initialData: [],
          builder: (_, snapshot) {
            return Column(
              children: snapshot.data.map((device) {
                return FlatIconButton(
                  device.name,
                  icon: Icons.bluetooth_connected_rounded,
                  color: Colors.green[400],
                  callBack: () async => await device.disconnect(),
                );
              }).toList(),
            );
          },
        ),
        ...snapshot.data.map((r) {
          return StreamBuilder<BluetoothDeviceState>(
            stream: r.device.state,
            builder: (_, snapshot) {
              if (snapshot.data == BluetoothDeviceState.connected) {
                return FlatIconButton(
                  r.device.name,
                  icon: Icons.bluetooth_connected_rounded,
                  color: Colors.green[400],
                  callBack: () async => await r.device.disconnect(),
                );
              } else {
                return FlatIconButton(
                  r.device.name,
                  icon: Icons.bluetooth_rounded,
                  color: Colors.deepOrange[400],
                  callBack: () async => await onConnect(r.device),
                );
              }
            },
          );
        })
      ],
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
