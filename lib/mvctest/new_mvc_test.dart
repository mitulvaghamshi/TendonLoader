import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
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
  final TextEditingController _ctrlTestDuration = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppStateScope.of(context).fieldEditable!) {
      _ctrlTestDuration.text = 10.toString();
    }
  }

  @override
  void dispose() {
    _ctrlTestDuration.dispose();
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
                  enabled: AppStateScope.of(context).fieldEditable!,
                  isPicker: true,
                  label: 'Test duration (sec)',
                  hint: 'Time duration to record MVC Test for.',
                  validator: _validator,
                  controller: _ctrlTestDuration,
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
