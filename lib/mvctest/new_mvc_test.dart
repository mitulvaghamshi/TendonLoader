import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/colors.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';

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

  @override
  void dispose() {
    _ctrlMvcDuration.dispose();
    super.dispose();
  }

  String? _validator(String? duration) {
    if (duration == null) return null;
    if (duration.isEmpty) {
      return '* required';
    } else if (int.tryParse(duration)! < 0) {
      return 'Test duration can\'t be negative.';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      AppStateScope.of(context).mvcDuration = int.parse(_ctrlMvcDuration.text);
      Navigator.pushReplacementNamed(context, MVCTesting.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start new MVC Test', textAlign: TextAlign.center)),
      body: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Text(
              'Please enter duration for the MVC Test.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Georgia',
                color: colorGoogleGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextField(
              isPicker: true,
              validator: _validator,
              label: 'Test duration (sec)',
              controller: _ctrlMvcDuration,
            ),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              CustomButton(
                text: const Text('Go'),
                color: colorGoogleGreen,
                icon: const Icon(Icons.done_rounded),
                onPressed: _submit,
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
