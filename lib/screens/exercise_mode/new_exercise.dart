import 'package:flutter/material.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/utils/exercise_data.dart';
import 'package:tendon_loader/utils/validator.dart' show ValidateExerciseDataMixin;

class NewExercise extends StatefulWidget {
  const NewExercise({Key key}) : super(key: key);

  static const String name = ExerciseMode.name;
  static const String route = '/newExercise';

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

  void _submit() {
    if (_exerciseFormKey.currentState.validate() || true) {
      Navigator.of(context).pushReplacementNamed(
        ExerciseMode.route,
        arguments: const ExerciseData(targetLoad: 5, holdTime: 5, restTime: 10, sets: 2, reps: 3),
        /*ExerciseData(
          sets: int.tryParse(_ctrlSets.text),
          reps: int.tryParse(_ctrlReps.text),
          holdTime: int.tryParse(_ctrlHoldTime.text),
          restTime: int.tryParse(_ctrlRestTime.text),
          targetLoad: double.tryParse(_ctrlTargetLoad.text),
        ),*/
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Exercise', textAlign: TextAlign.center)),
      body: AppFrame(
        isScrollable: true,
        child: Form(
          key: _exerciseFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Please enter your\nexercise prescriptions',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontFamily: 'Georgia', fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                label: 'Target Load',
                hint: 'Target load (kg) e.g. 6.5',
                desc: '~70% of last recorded MVC test',
                controller: _ctrlTargetLoad,
                validator: validateTargetLoad,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'Hold time',
                hint: 'Select hold time (sec)',
                desc: 'Amount of time you can keep holding at target load',
                isPicker: true,
                controller: _ctrlHoldTime,
                validator: validateHoldTime,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'Rest time',
                hint: 'Select rest time (sec)',
                desc: 'Amount of time you can rest after every rep',
                isPicker: true,
                controller: _ctrlRestTime,
                validator: validateRestTime,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'Sets',
                desc: 'Number of total sets',
                hint: 'Enter # of sets e.g. 3',
                controller: _ctrlSets,
                validator: validateSets,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'Reps',
                hint: 'Enter # of reps (#) e.g. 5',
                desc: 'Number of reps to perform in each set',
                controller: _ctrlReps,
                validator: validateReps,
                action: TextInputAction.send,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <CustomButton>[
                  CustomButton(text: 'Submit', background: Colors.blue, color: Colors.white, icon: Icons.done_rounded, onPressed: _submit),
                  CustomButton(
                    text: 'Clear all',
                    icon: Icons.clear_rounded,
                    onPressed: () => _exerciseFormKey.currentState.reset(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
