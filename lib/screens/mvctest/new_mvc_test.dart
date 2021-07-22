import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/textstyles.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/handlers/validator.dart';

class NewMVCTest extends StatefulWidget {
  const NewMVCTest({Key? key}) : super(key: key);

  static const String name = MVCTesting.name;
  static const String route = '/newMVCTest';

  @override
  _NewMVCTestState createState() => _NewMVCTestState();
}

class _NewMVCTestState extends State<NewMVCTest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlMvcDuration = TextEditingController();
  late final int? _lastDuration = context.model.settingsState!.lastDuration;
  bool _useLastDuration = false;

  @override
  void dispose() {
    _ctrlMvcDuration.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final int _duration = int.parse(_ctrlMvcDuration.text);
      context.model
        ..mvcDuration = _duration
        ..settingsState!.lastDuration = _duration;
      await context.model.settingsState!.save();
      await context.push(MVCTesting.route, replace: true);
    }
  }

  void _onChanged(bool value) {
    _ctrlMvcDuration.text = value ? _lastDuration.toString() : '';
    setState(() => _useLastDuration = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New MVC Test', textAlign: TextAlign.center), actions: <Widget>[
        CustomButton(
          reverce: true,
          onPressed: _onSubmit,
          icon: const Icon(Icons.arrow_forward_rounded, color: colorGoogleGreen),
          child: const Text('Go', style: tsG18BFF),
        ),
      ]),
      body: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Text('MVC Test duration.', style: tsG24BFF, textAlign: TextAlign.center),
            if (_lastDuration != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SwitchListTile.adaptive(
                  onChanged: _onChanged,
                  value: _useLastDuration,
                  title: const Text('Use duration from last test.'),
                ),
              ),
            CustomTextField(
              isPicker: true,
              label: 'Test duration (sec)',
              controller: _ctrlMvcDuration,
              validator: validateNum,
            ),
          ]),
        ),
      ),
    );
  }
}
