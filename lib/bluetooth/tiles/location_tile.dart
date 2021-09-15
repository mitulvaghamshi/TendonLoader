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

import 'package:app_settings/app_settings.dart' as ast;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/bluetooth/tiles/start_scan_tile.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/utils/constants.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: Stream<bool?>.periodic(const Duration(milliseconds: 500))
          .asyncMap((_) async => Location.instance.serviceEnabled()),
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.hasData && snapshot.data!) return const StartScanTile();
        return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          CustomImage(name: imgEnableLocation),
          Text(
            descLocationLine1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            descLocationLine3,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          CustomButton(
            onPressed: ast.AppSettings.openLocationSettings,
            left: Icon(Icons.location_on_rounded),
            right: Text('Open Settings'),
          ),
        ]);
      },
    );
  }
}
