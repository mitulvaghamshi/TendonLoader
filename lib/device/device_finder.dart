import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/device/connected_list.dart';
import 'package:tendon_loader/device/device_list.dart';
import 'package:tendon_loader/device/scanner_tile.dart';
import 'package:tendon_loader/device/tiles/enable_bluetooth_tile.dart';
import 'package:tendon_loader/device/tiles/enable_location_tile.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/location_handler.dart';

class DeviceFinder extends StatelessWidget {
  const DeviceFinder({Key? key}) : super(key: key);

  static const String route = '/deviceFinder';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppFrame(
        child: SingleChildScrollView(
          child: ExpansionPanelList.radio(
            expansionCallback: (int panelIndex, bool isExpanded) {},
            children: <ExpansionPanelRadio>[
              ExpansionPanelRadio(
                value: 1,
                body: const EnableBluetoothTile(),
                headerBuilder: (_, bool isExpanded) {
                  return const CustomButton(
                    onPressed: openBluetoothSetting,
                    icon: Icon(Icons.bluetooth_rounded),
                    child: Text('Enable Bluetooth'),
                  );
                },
              ),
              ExpansionPanelRadio(
                value: 2,
                canTapOnHeader: true,
                body: const EnableLocationTile(),
                headerBuilder: (_, bool isExpanded) {
                  return const CustomButton(
                    onPressed: enableLocation,
                    icon: Icon(Icons.location_on_rounded),
                    child: Text('Enable Location'),
                  );
                },
              ),
              ExpansionPanelRadio(
                value: 3,
                canTapOnHeader: true,
                body: const DeviceList(),
                headerBuilder: (_, bool isExpanded) {
                  return const Text('Search Result');
                },
              ),
              ExpansionPanelRadio(
                value: 4,
                canTapOnHeader: true,
                body: const ConnectedList(),
                headerBuilder: (_, bool isExpanded) {
                  return const Text('Connected Devices');
                },
              ),
              ExpansionPanelRadio(
                value: 5,
                canTapOnHeader: true,
                body: const ScannerTile(),
                headerBuilder: (_, bool isExpanded) {
                  return const Text('Device Scanner');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
