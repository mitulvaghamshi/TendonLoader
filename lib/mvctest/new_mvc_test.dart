import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/colors.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/utils/validator.dart';

class NewMVCTest extends StatefulWidget {
  const NewMVCTest({Key? key}) : super(key: key);

  static const String name = MVCTesting.name;
  static const String route = '/newMVCTest';

  @override
  _NewMVCTestState createState() => _NewMVCTestState();

  static Future<void> show(BuildContext context) async {
    AppStateScope.of(context).togglePrescription();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        content: const NewMVCTest(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Start MVC Test', textAlign: TextAlign.center),
            CustomButton(
              reverce: true,
              icon: const Icon(Icons.arrow_forward_rounded, color: colorGoogleGreen),
              onPressed: () async {
                if (AppStateScope.of(context).mvcDuration != null) {
                  await Navigator.pushReplacementNamed(context, MVCTesting.route);
                }
              },
              child: const Text('Go', style: TextStyle(color: colorGoogleGreen)),
            ),
          ],
        ),
      ),
    );
  }
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
  void initState() {
    super.initState();
    _ctrlMvcDuration.addListener(() {
      if (_formKey.currentState!.validate()) {
        AppStateScope.of(context).mvcDuration = int.tryParse(_ctrlMvcDuration.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Text(
          'MVC Test duration.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Georgia',
            color: colorGoogleGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (AppStateScope.of(context).fieldEditable!)
          CustomTextField(
            isPicker: true,
            label: 'Test duration (sec)',
            controller: _ctrlMvcDuration,
            validator: validateTestDuration,
          )
        else
          Text(
            '${AppStateScope.of(context).mvcDuration} Sec.',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
      ]),
    );
  }
}
