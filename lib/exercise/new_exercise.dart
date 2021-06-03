import 'package:flutter/material.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_support_lib/tendon_support_lib.dart'
    show AppFrame, CustomButton, CustomTextField, ValidatePrescription, Prescription;

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key}) : super(key: key);

  static const String name = ExerciseMode.name;
  static const String route = '/newExercise';

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> with ValidatePrescription {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlHoldTime = TextEditingController();
  final TextEditingController _ctrlRestTime = TextEditingController();
  final TextEditingController _ctrlSetRestTime = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();

  @override
  void dispose() {
    _ctrlSets.dispose();
    _ctrlReps.dispose();
    _ctrlHoldTime.dispose();
    _ctrlRestTime.dispose();
    _ctrlTargetLoad.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() || true) {
      Navigator.of(context).pushReplacementNamed(
        ExerciseMode.route,
        arguments:
            /* Prescription(
          sets: int.tryParse(_ctrlSets.text),
          reps: int.tryParse(_ctrlReps.text),
          holdTime: int.tryParse(_ctrlHoldTime.text),
          restTime: int.tryParse(_ctrlRestTime.text),
          targetLoad: double.tryParse(_ctrlTargetLoad.text),
          setRestTime: int.tryParse(_ctrlSetRestTime.text) ?? 90,
        ), */
            const Prescription(sets: 2, reps: 3, holdTime: 5, restTime: 3, targetLoad: 6, setRestTime: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Exercise', textAlign: TextAlign.center)),
      body: SingleChildScrollView(
        child: AppFrame(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Please enter your\nexercise prescriptions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor.withOpacity(0.8),
                  ),
                ),
                CustomTextField(
                  label: 'Target Load (kg)',
                  hint: '~70% of last MVC test',
                  controller: _ctrlTargetLoad,
                  validator: validateTargetLoad,
                  pattern: r'^\d{1,2}(\.\d{0,2})?',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                CustomTextField(
                  isPicker: true,
                  label: 'Hold time (sec)',
                  hint: 'Amount of time you can keep holding at target load.',
                  controller: _ctrlHoldTime,
                  validator: validateHoldTime,
                ),
                CustomTextField(
                  isPicker: true,
                  label: 'Rest time (sec)',
                  hint: 'Amount of time you can rest after each rep.',
                  controller: _ctrlRestTime,
                  validator: validateRestTime,
                ),
                CustomTextField(
                  label: 'Sets (#)',
                  hint: 'Number of total sets.',
                  controller: _ctrlSets,
                  validator: validateSets,
                  pattern: r'^\d{1,2}',
                ),
                CustomTextField(
                  label: 'Reps (#)',
                  hint: 'Number of reps to perform in each set.',
                  controller: _ctrlReps,
                  validator: validateReps,
                  pattern: r'^\d{1,2}',
                ),
                CustomTextField(
                  isPicker: true,
                  label: 'Rest time b/w Sets (sec)',
                  hint: 'Amount of time you can rest after every set (default: 90 sec).',
                  controller: _ctrlSetRestTime,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButton(
                      text: 'Submit',
                      onPressed: _submit,
                      color: Colors.white,
                      background: Colors.blue,
                      icon: Icons.done_rounded,
                    ),
                    CustomButton(
                      text: 'Clear all',
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
