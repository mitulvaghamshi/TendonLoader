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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomTextField(
                  hint: 'Target Load (kg)',
                  helper: 'What this field mean?',
                  controller: _ctrlTargetLoad,
                ),
                CustomTextField(
                  isPicker: true,
                  hint: 'Hold time (sec)',
                  helper: 'What this field mean?',
                  controller: _ctrlHoldTime,
                ),
                CustomTextField(
                  hint: 'Sets (#)',
                  helper: 'What this field mean?',
                  controller: _ctrlSets,
                ),
                CustomTextField(
                  hint: 'Reps (#)',
                  helper: 'What this field mean?',
                  controller: _ctrlReps,
                ),
                CustomTextField(
                  isPicker: true,
                  hint: 'Rest time (sec)',
                  helper: 'What this field mean?',
                  controller: _ctrlRestTime,
                ),
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
