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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final int? _lastDuration = context.model.settingsState!.lastDuration;
  Duration _mvcTime = const Duration();
  bool _useLastDuration = false;

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final int _duration = _mvcTime.inSeconds;
      context.model.mvcDuration = _duration;
      context.model.settingsState!.lastDuration = _duration;
      await context.model.settingsState!.save();
      await context.push(MVCTesting.route, replace: true);
    }
  }

  void _onChanged(bool value) {
    _mvcTime = Duration(seconds: value ? _lastDuration! : 0);
    setState(() => _useLastDuration = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New MVC Test'), actions: <Widget>[
        CustomButton(
          onPressed: _onSubmit,
          left: const Text('Go', style: ts18BFF),
          right: const Icon(Icons.arrow_forward, color: colorBlue),
        ),
      ]),
      body: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Text('MVC Test duration.', style: tsG24BFF, textAlign: TextAlign.center),
            if (_lastDuration != null)
              SwitchListTile.adaptive(
                onChanged: _onChanged,
                value: _useLastDuration,
                activeColor: colorGoogleGreen,
                title: const Text('Use duration from last test.'),
              ),
            CustomTimeTile(
              time: _mvcTime,
              desc: 'MVC test duration',
              onChanged: (Duration duration) => setState(() => _mvcTime = duration),
            ),
          ]),
        ),
      ),
    );
  }
}
