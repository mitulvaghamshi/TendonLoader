/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/progress_tile.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class ConnectedTile extends StatelessWidget {
  const ConnectedTile({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getProps(device),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData || !snapshot.data!) return const CustomProgress();
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            onLongPress: disconnectDevice,
            contentPadding: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              deviceName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Long press to disconnect',
              style: TextStyle(fontSize: 12, color: colorErrorRed),
            ),
            leading: const CustomButton(
              rounded: true,
              color: colorMidGreen,
              left: Icon(
                Icons.bluetooth_connected,
                color: colorPrimaryWhite,
              ),
            ),
          ),
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: GraphHandler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) => Text(
              '${snapshot.data!.load.toStringAsFixed(1)} Kg.',
              style: tsG40B,
            ),
          ),
          const Text(
            descTareProgressor,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          CustomButton(
            left: const Icon(Icons.adjust),
            right: const Text('Tare Progressor'),
            onPressed: () async => tareProgressor().then(context.pop),
          ),
        ]);
      },
    );
  }
}
