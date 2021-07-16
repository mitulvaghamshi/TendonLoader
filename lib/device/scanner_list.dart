import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/device/connected_tile.dart';
import 'package:tendon_loader/device/tiles/progressor_tile.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({Key? key}) : super(key: key);

  String _deviceName(BluetoothDevice device) => device.name.isEmpty ? device.id.id : device.name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final Iterable<ScanResult> results = snapshot.data!.where((ScanResult result) {
            return _deviceName(result.device).contains('Progressor');
          });
          if (results.isNotEmpty) {
            return Column(
                children: results.map((ScanResult result) {
              return StreamBuilder<BluetoothDeviceState>(
                stream: result.device.state,
                builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
                  if (snapshot.data == BluetoothDeviceState.connected) {
                    return ConnectedTile(device: result.device);
                  } else {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          onTap: result.device.connect,
                          contentPadding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12)),
                          title: Text(_deviceName(result.device), style: const TextStyle(fontWeight: FontWeight.bold)),
                          leading: const CustomButton(
                            radius: 25,
                            color: colorRed400,
                            icon: Icon(Icons.bluetooth_rounded, size: 30),
                          ),
                        ),
                        const CustomButton(icon: Icon(Icons.search), onPressed: startDeviceScan, child: Text('Scan')),
                      ],
                    );
                  }
                },
              );
            }).toList());
          } else {
            return const ProgressorTile();
          }
        } else {
          return const ProgressorTile();
        }
      },
    );
  }
}
