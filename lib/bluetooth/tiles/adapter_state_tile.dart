import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key key, @required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth is ${state != null ? state.toString().split('.')[1] : 'not available'}.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.error,
          color: Colors.white,
        ),
      ),
    );
  }
}
