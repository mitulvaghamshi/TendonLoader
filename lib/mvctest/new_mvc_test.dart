import 'package:flutter/material.dart';
import 'package:tendon_loader/settings/settings_model.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class NewMVCTest extends StatefulWidget {
  const NewMVCTest({Key? key}) : super(key: key);

  static const String name = MVCTesting.name;
  static const String route = '/newMVCTest';

  @override
  _NewMVCTestState createState() => _NewMVCTestState();
}

class _NewMVCTestState extends State<NewMVCTest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlTestDuration = TextEditingController();
  final bool _enabled = SettingsModel.editableExercise!;

  @override
  void initState() {
    super.initState();
    if (!_enabled) {
      _ctrlTestDuration.text = 10.toString();
    }
  }

  @override
  void dispose() {
    _ctrlTestDuration.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(
        MVCTesting.route,
        arguments: int.tryParse(_ctrlTestDuration.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start new MVC Test', textAlign: TextAlign.center)),
      body: SingleChildScrollView(
        child: AppFrame(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Please enter duration for the MVC Test.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor.withOpacity(0.8),
                  ),
                ),
                CustomTextField(
                  enabled: _enabled,
                  isPicker: true,
                  label: 'Test duration (sec)',
                  hint: 'Time duration to record MVC Test for.',
                  controller: _ctrlTestDuration,
                  validator: (String? duration) {
                    if (duration != null) {
                      if (duration.isEmpty) {
                        return '* required';
                      } else if (int.tryParse(duration)! < 0) {
                        return 'Test duration can\'t be negative.';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButton(
                      text: 'Go',
                      onPressed: _submit,
                      color: Colors.white,
                      background: const Color.fromRGBO(61, 220, 132, 1),
                      icon: Icons.arrow_forward_rounded,
                    ),
                    CustomButton(
                      text: 'Clear',
                      icon: Icons.clear_rounded,
                      onPressed: () => _formKey.currentState!.reset(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
