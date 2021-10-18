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
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/time_picker_tile.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class NewMVCTest extends StatefulWidget {
  const NewMVCTest({Key? key}) : super(key: key);

  static const String name = MVCTesting.name;
  static const String route = '/newMVCTest';

  @override
  _NewMVCTestState createState() => _NewMVCTestState();
}

class _NewMVCTestState extends State<NewMVCTest> {
  late final int? _lastDuration = settingsState.mvcDuration;
  bool _useLastDuration = false;
  int _duration = 0;

  Future<void> _onSubmit() async {
    if (_duration > 0) {
      settingsState.mvcDuration = _duration;
      await settingsState.save();
      await context.replace(MVCTesting.route);
    } else {
      context.showSnackBar(const Text('Please select test duration.'));
    }
  }

  void _onChanged(bool value) {
    _duration = value ? _lastDuration! : 0;
    setState(() => _useLastDuration = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New MVC Test'), actions: <Widget>[
        CustomButton(
          onPressed: _onSubmit,
          left: const Text('Go', style: ts18w5),
          right: const Icon(Icons.arrow_forward, color: colorMidGreen),
        ),
      ]),
      body: AppFrame(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Text('MVC Test duration', style: tsG24B),
          if (_lastDuration != null)
            SwitchListTile.adaptive(
              onChanged: _onChanged,
              activeColor: colorIconBlue,
              value: _useLastDuration,
              title: const Text('Use duration from last test.'),
            ),
          const SizedBox(height: 10),
          TimePickerTile(
            time: _duration,
            desc: 'MVC test duration',
            title: 'Select test duration',
            onChanged: (int duration) {
              setState(() => _duration = duration);
            },
          ),
        ]),
      ),
    );
  }
}
