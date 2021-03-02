import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/components/bluetooth.dart';
import 'package:tendon_loader/components/custom_button.dart';

class DeviceScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (_, snapshot) {
        if (snapshot.data == BluetoothState.on) {
          return StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: [],
            builder: (_, snapshot) {
              if (snapshot.data.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...snapshot.data.map((r) {
                      Bluetooth.instance.setDevice(r.device);
                      return StreamBuilder<BluetoothDeviceState>(
                        stream: r.device.state,
                        builder: (_, snapshot) {
                          if (snapshot.data == BluetoothDeviceState.connected) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Device is connected successfully and ready to use!\nClick on the device name to disconnect.',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: r.device.name,
                                  color: Colors.green[700],
                                  icon: Icons.bluetooth_connected_rounded,
                                  onPressed: () async {
                                    await Bluetooth.instance.disconnect();
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: 'Close',
                                  color: Colors.black,
                                  icon: Icons.cancel,
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Click on the device name to connect\n Note: this might take a moment to connect.',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: r.device.name,
                                  icon: Icons.bluetooth_rounded,
                                  color: Colors.deepOrange[700],
                                  onPressed: () async {
                                    await Bluetooth.instance.connect();
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }),
                  ],
                );
              } else {
                return StreamBuilder<bool>(
                  stream: FlutterBlue.instance.isScanning,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (snapshot.data) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const CircularProgressIndicator(),
                              const Text('Please wait...', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Stop',
                            icon: Icons.close_rounded,
                            color: Colors.deepOrangeAccent,
                            onPressed: () async => Bluetooth.instance.stopScan(),
                          ),
                        ],
                      );
                    } else {
                      final StreamController<bool> _locationStateController = StreamController<bool>();
                      return StreamBuilder<bool>(
                        stream: _locationStateController.stream,
                        initialData: true,
                        builder: (_, snapshot) {
                          if (snapshot.data) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/enable_device.webp', width: 180),
                                const Text(
                                  'Activate your device by pressing the button, then press scan to find the device',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  text: 'Scan',
                                  icon: Icons.search_rounded,
                                  color: Colors.black,
                                  onPressed: () async {
                                    await Location.instance.serviceEnabled().then((value) async {
                                      if (value) {
                                        await Bluetooth.instance.startScan();
                                        if (!_locationStateController.isClosed) _locationStateController.close();
                                      } else {
                                        _locationStateController.add(value);
                                      }
                                    });
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/enable_location.webp', width: 180),
                                const Text(
                                  'This app uses bluetooth to communicate with your Progressor.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Scanning for bluetooth devices can be used to locate you. That\'s why we ask you to permit location services. We\'re only using this permission to scan for your Progressor.',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'We\'ll never collect your physical location.',
                                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  text: 'Enable',
                                  icon: Icons.location_on_rounded,
                                  color: Colors.black,
                                  onPressed: () async => await Location.instance.requestService().then((value) {
                                    _locationStateController.add(value);
                                  }),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/enable_bluetooth.webp', width: 180),
              const Text(
                'This app needs Bluetooth to communicate with your Progressor. Please enable Bluetooth on your device.',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              CustomButton(
                text: 'Enable',
                icon: Icons.bluetooth_rounded,
                color: Colors.black,
                onPressed: () async => await Bluetooth.instance.enable(),
              ),
            ],
          );
        }
      },
    );
  }
}
