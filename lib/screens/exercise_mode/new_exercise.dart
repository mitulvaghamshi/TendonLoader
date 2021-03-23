import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/utils/exercise_data.dart';
import 'package:tendon_loader/utils/validator.dart' show ValidateExerciseDataMixin;

class NewExercise extends StatefulWidget {
  const NewExercise({Key key}) : super(key: key);

  static const name = ExerciseMode.name;
  static const routeName = '/newExercise';

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> with ValidateExerciseDataMixin {
  final GlobalKey<FormState> _exerciseFormKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlHoldTime = TextEditingController();
  final TextEditingController _ctrlRestTime = TextEditingController();
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

/*
  void _clear() {
    _ctrlTargetLoad.clear();
    _ctrlHoldTime.clear();
    _ctrlSets.clear();
    _ctrlReps.clear();
    _ctrlRestTime.clear();
  }*/

/*  bool _validate() {
    return _ctrlTargetLoad.text.isNotEmpty &&
        _ctrlHoldTime.text.isNotEmpty &&
        _ctrlSets.text.isNotEmpty &&
        _ctrlReps.text.isNotEmpty &&
        _ctrlRestTime.text.isNotEmpty;
  }*/

  void _submit() {
    if (true || _exerciseFormKey.currentState.validate()) {
      Navigator.of(context).pushReplacementNamed(
        ExerciseMode.routeName,
        //TODO: test exercise data (replace with commented one below)
        arguments: ExerciseData(targetLoad: 5, holdTime: 5, restTime: 10, sets: 2, reps: 3),
        /*
        ExerciseData(
          sets: int.tryParse(_ctrlSets.text) ?? 0,
          reps: int.tryParse(_ctrlReps.text) ?? 0,
          holdTime: int.tryParse(_ctrlHoldTime.text) ?? 0,
          restTime: int.tryParse(_ctrlRestTime.text) ?? 0,
          targetLoad: double.tryParse(_ctrlTargetLoad.text) ?? 0,
        ),
        */
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Exercise', textAlign: TextAlign.center)),
      body: Card(
        elevation: 16,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _exerciseFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Please enter your\nexercise prescriptions',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontFamily: 'Georgia', fontWeight: FontWeight.bold),
                ),
                // const Text('* All fields are required.', style: const TextStyle(color: Colors.red), textAlign: TextAlign.right),
                CustomTextField(
                  label: 'Target Load',
                  controller: _ctrlTargetLoad,
                  hint: 'Target Load (kg) e.g. 6.5',
                  keyboardType: TextInputType.number,
                  desc: '~70% of last recorded MVC test',
                  validator: validateTargetLoad,
                ),
                CustomTextField(
                  isPicker: true,
                  label: 'Hold time',
                  hint: 'Hold time (sec)',
                  controller: _ctrlHoldTime,
                  keyboardType: TextInputType.number,
                  validator: validateHoldTime,
                  desc: 'Amount of time you can keep holding at target load',
                ),
                CustomTextField(
                  isPicker: true,
                  label: 'Rest time',
                  hint: 'Rest time (sec)',
                  controller: _ctrlRestTime,
                  keyboardType: TextInputType.number,
                  validator: validateRestTime,
                  desc: 'Amount of time you can rest after every rep',
                ),
                CustomTextField(
                  label: 'Sets',
                  controller: _ctrlSets,
                  hint: 'Sets (#) e.g. 5',
                  desc: 'Number of total sets',
                  validator: validateSets,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  label: 'Reps',
                  hint: 'Reps (#)',
                  controller: _ctrlReps,
                  validator: validateReps,
                  keyboardType: TextInputType.number,
                  desc: 'Number of reps to perform in each set',
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(text: 'Submit', color: Colors.blue, icon: Icons.done_rounded, onPressed: _submit),
                    CustomButton(
                      text: 'Clear all',
                      color: Colors.grey,
                      icon: Icons.clear_rounded,
                      onPressed: () => _exerciseFormKey.currentState.reset(),
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
