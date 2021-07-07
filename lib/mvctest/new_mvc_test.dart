import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New MVC Test', textAlign: TextAlign.center),
        actions: <Widget>[
          CustomButton(
            reverce: true,
            icon: const Icon(Icons.arrow_forward_rounded, color: googleGreen),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                AppStateScope.of(context).mvcDuration = int.parse(_ctrlMvcDuration.text);
                await Navigator.pushReplacementNamed(context, MVCTesting.route);
              }
            },
            child: const Text('Go', style: TextStyle(color: googleGreen)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AppFrame(
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'MVC Test duration.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Georgia',
                  color: googleGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                isPicker: true,
                label: 'Test duration (sec)',
                controller: _ctrlMvcDuration,
                validator: validateNum,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
