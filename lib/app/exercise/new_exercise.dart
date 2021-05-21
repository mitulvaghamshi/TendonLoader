import 'package:flutter/material.dart';
import 'package:tendon_loader/app/custom/custom_textfield.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/validator.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key}) : super(key: key);

  static const String name = ExerciseMode.name;
  static const String route = '/newExercise';

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> with ValidateExerciseDataMixin {
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
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(
        ExerciseMode.route,
        arguments: Prescription(
          sets: int.tryParse(_ctrlSets.text),
          reps: int.tryParse(_ctrlReps.text),
          holdTime: int.tryParse(_ctrlHoldTime.text),
          restTime: int.tryParse(_ctrlRestTime.text),
          targetLoad: double.tryParse(_ctrlTargetLoad.text),
          setRestTime: int.tryParse(_ctrlSetRestTime.text),
        ),
      );
    }
  }

  // Prescription(targetLoad: 5, sets: 2, reps: 2, holdTime: 5, restTime: 3),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Exercise', textAlign: TextAlign.center)),
      body: AppFrame(
        isScrollable: true,
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
                  color: Theme.of(context).accentColor.withOpacity(0.6),
                ),
              ),
              CustomTextField(
                label: 'Target Load',
                hint: 'Target load (kg) e.g. 6.5',
                desc: '~70% of last MVC test',
                controller: _ctrlTargetLoad,
                validator: validateTargetLoad,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                isPicker: true,
                label: 'Hold time',
                hint: 'Select hold time (sec)',
                desc: 'Amount of time you can keep holding at target load',
                controller: _ctrlHoldTime,
                validator: validateHoldTime,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                isPicker: true,
                label: 'Rest time',
                hint: 'Select rest time (sec)',
                desc: 'Amount of time you can rest after every rep',
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
                hint: 'Enter # of reps e.g. 5',
                desc: 'Number of reps to perform in each set',
                controller: _ctrlReps,
                validator: validateReps,
                action: TextInputAction.send,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                isPicker: true,
                label: 'Rest time b/w Sets',
                hint: 'Select rest time for set (sec)',
                desc: 'Amount of time you can rest after every set',
                controller: _ctrlSetRestTime,
                validator: validateRestTime,
                keyboardType: TextInputType.number,
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
    );
  }
}
