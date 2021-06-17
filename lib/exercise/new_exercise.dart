import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/exercise/validator.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key}) : super(key: key);

  static const String name = ExerciseMode.name;
  static const String route = '/newExercise';

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlHoldTime = TextEditingController();
  final TextEditingController _ctrlRestTime = TextEditingController();
  final TextEditingController _ctrlSetRest = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();

  @override
  void dispose() {
    _ctrlSets.dispose();
    _ctrlReps.dispose();
    _ctrlHoldTime.dispose();
    _ctrlRestTime.dispose();
    _ctrlTargetLoad.dispose();
    _ctrlSetRest.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // todo(me): replace with actual values
    if (!AppStateScope.of(context).fieldEditable!) {
      _ctrlSets.text = 2.toString();
      _ctrlReps.text = 3.toString();
      _ctrlHoldTime.text = 5.toString();
      _ctrlRestTime.text = 5.toString();
      _ctrlTargetLoad.text = 6.toString();
      _ctrlSetRest.text = 10.toString();
    }
  }

  void _submit() {
    // todo(me): remove explicitely forced true value
    if (_formKey.currentState!.validate() || true) {
      Navigator.of(context).pushReplacementNamed(
        ExerciseMode.route,
        arguments: const Prescription(sets: 5, reps: 10, holdTime: 10, restTime: 15, targetLoad: 6, setRest: 5),
        /* Prescription(
          sets: int.parse(_ctrlSets.text),
          reps: int.parse(_ctrlReps.text),
          holdTime: int.parse(_ctrlHoldTime.text),
          restTime: int.parse(_ctrlRestTime.text),
          setRest: int.parse(_ctrlSetRestTime.text),
          targetLoad: double.parse(_ctrlTargetLoad.text),
        ), */
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
                  enabled: AppStateScope.of(context).fieldEditable!,
                  label: 'Target Load (kg)',
                  hint: '~70% of last MVC test',
                  controller: _ctrlTargetLoad,
                  validator: validateTargetLoad,
                  pattern: r'^\d{1,2}(\.\d{0,2})?',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                CustomTextField(
                  enabled: AppStateScope.of(context).fieldEditable!,
                  isPicker: true,
                  label: 'Hold time (sec)',
                  hint: 'Amount of time you can keep holding at target load.',
                  controller: _ctrlHoldTime,
                  validator: validateHoldTime,
                ),
                CustomTextField(
                  enabled: AppStateScope.of(context).fieldEditable!,
                  isPicker: true,
                  label: 'Rest time (sec)',
                  hint: 'Amount of time you can rest after each rep.',
                  controller: _ctrlRestTime,
                  validator: validateRestTime,
                ),
                CustomTextField(
                  enabled: AppStateScope.of(context).fieldEditable!,
                  label: 'Sets (#)',
                  hint: 'Number of total sets.',
                  controller: _ctrlSets,
                  validator: validateSets,
                  pattern: r'^\d{1,2}',
                ),
                CustomTextField(
                  enabled: AppStateScope.of(context).fieldEditable!,
                  label: 'Reps (#)',
                  hint: 'Number of reps to perform in each set.',
                  controller: _ctrlReps,
                  validator: validateReps,
                  pattern: r'^\d{1,2}',
                ),
                CustomTextField(
                  enabled: AppStateScope.of(context).fieldEditable!,
                  isPicker: true,
                  label: 'Rest time b/w Sets (sec)',
                  hint: 'Amount of time you can rest after every set (default: 90 sec).',
                  controller: _ctrlSetRest,
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
