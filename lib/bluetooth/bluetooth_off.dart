import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOff extends StatelessWidget {
  final BluetoothState state;
  static const routeName = '/bluetoothOff';

  const BluetoothOff({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              color: Colors.white,
              size: 200.0,
            ),
            Text(
              'Bluetooth is ${state != null ? state.toString().split(".")[1] : 'not available'}.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
