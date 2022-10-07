import 'package:flutter/material.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/app/widgets/time_picker_tile.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/utils/routes.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/shared/widgets/frame_widget.dart';

class NewMVCTest extends StatefulWidget {
  const NewMVCTest({super.key});

  static const String name = MVCTesting.name;
  static const String route = '/newmvctest';

  @override
  NewMVCTestState createState() => NewMVCTestState();
}

class NewMVCTestState extends State<NewMVCTest> {
  late final int? _lastDuration = settingsState.mvcDuration;
  bool _useLastDuration = false;
  int _duration = 0;

  Future<void> _onSubmit() async {
    if (_duration > 0) {
      settingsState.mvcDuration = _duration;
      await settingsState.save();
      if (!mounted) return;
      await Navigator.pushReplacement(
          context, buildRoute<void>(MVCTesting.route));
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
      appBar: AppBar(
        elevation: 0,
        title: const Text('New MVC Test'),
        actions: <Widget>[
          ButtonWidget(
            onPressed: _onSubmit,
            left: const Text(
              'Go',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            right: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: FrameWidget(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'MVC Test duration',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xff3ddc85),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_lastDuration != null)
                SwitchListTile.adaptive(
                  onChanged: _onChanged,
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
            ],
          ),
        ),
      ),
    );
  }
}
