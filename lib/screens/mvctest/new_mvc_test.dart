import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_time_tile.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
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
  late final int? _lastDuration = context.settingsState.mvcDuration;
  bool _useLastDuration = false;
  int _duration = 0;

  Future<void> _onSubmit() async {
    if (_duration > 0) {
      context.settingsState.mvcDuration = _duration;
      await context.settingsState.save();
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
          left: const Text('Go', style: ts18B),
          right: const Icon(Icons.arrow_forward, color: colorGoogleGreen),
        ),
      ]),
      body: AppFrame(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Text('MVC Test duration', style: tsG24B),
          if (_lastDuration != null)
            SwitchListTile.adaptive(
              onChanged: _onChanged,
              activeColor: colorBlue,
              value: _useLastDuration,
              title: const Text('Use duration from last test.'),
            ),
          const SizedBox(height: 10),
          CustomTimeTile(
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
