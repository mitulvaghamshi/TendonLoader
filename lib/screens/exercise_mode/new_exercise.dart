import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class NewExercise extends StatefulWidget {
  static const name = ExerciseMode.name;
  static const routeName = '/newExercise';

  const NewExercise({Key key});

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  TextEditingController _ctrlSets = TextEditingController();
  TextEditingController _ctrlReps = TextEditingController();
  TextEditingController _ctrlHoldTime = TextEditingController();
  TextEditingController _ctrlRestTime = TextEditingController();
  TextEditingController _ctrlTargetLoad = TextEditingController();

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _clear() {
    _ctrlTargetLoad.clear();
    _ctrlHoldTime.clear();
    _ctrlSets.clear();
    _ctrlReps.clear();
    _ctrlRestTime.clear();
  }

  void _dispose() {
    _ctrlSets.dispose();
    _ctrlReps.dispose();
    _ctrlHoldTime.dispose();
    _ctrlRestTime.dispose();
    _ctrlTargetLoad.dispose();
  }

  bool _validate() {
    return _ctrlTargetLoad.text.isNotEmpty &&
        _ctrlHoldTime.text.isNotEmpty &&
        _ctrlSets.text.isNotEmpty &&
        _ctrlReps.text.isNotEmpty &&
        _ctrlRestTime.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Exercise', textAlign: TextAlign.center)),
      body: SafeArea(
        child: Card(
          elevation: 16,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Please enter your\nexercise prescriptions',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFamily: 'Georgia',
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const Text('* All fields are required.', style: const TextStyle(color: Colors.red), textAlign: TextAlign.right),
                CustomTextField(
                  hint: 'Target Load (kg)',
                  helper: '~70% of last recorded MVC test',
                  controller: _ctrlTargetLoad,
                ),
                CustomTextField(
                  isPicker: true,
                  hint: 'Hold time (sec)',
                  helper: 'Amount of time you can keep holding at target load',
                  controller: _ctrlHoldTime,
                ),
                CustomTextField(
                  isPicker: true,
                  hint: 'Rest time (sec)',
                  helper: 'Amount of time you can rest after every rep',
                  controller: _ctrlRestTime,
                ),
                CustomTextField(
                  hint: 'Sets (#)',
                  helper: 'Number of total sets',
                  controller: _ctrlSets,
                ),
                CustomTextField(
                  hint: 'Reps (#)',
                  helper: 'Number of reps to perform in each set',
                  controller: _ctrlReps,
                ),
                // Text('* All fields are required.', style: const TextStyle(color: Colors.red), textAlign: TextAlign.left),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Submit',
                      color: Colors.blue,
                      icon: Icons.done_rounded,
                      onPressed: () {
                        if (true || _validate()) {
                          Navigator.pushReplacementNamed(
                            context,
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
                      },
                    ),
                    CustomButton(text: 'Clear all', icon: Icons.clear_rounded, color: Colors.grey, onPressed: _clear),
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
