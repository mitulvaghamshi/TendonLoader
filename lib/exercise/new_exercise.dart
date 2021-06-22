import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/colors.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/validator.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key}) : super(key: key);

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

  void _submit() {
    // todo(me): remove explicitely forced true value
    /* const Prescription(sets: 5, reps: 10, holdTime: 10, restTime: 15, targetLoad: 6, setRest: 5), */
    if (_formKey.currentState!.validate() || true) {
      AppStateScope.of(context).prescription = Prescription(
        sets: int.parse(_ctrlSets.text),
        reps: int.parse(_ctrlReps.text),
        setRest: int.parse(_ctrlSetRest.text),
        holdTime: int.parse(_ctrlHoldTime.text),
        restTime: int.parse(_ctrlRestTime.text),
        targetLoad: double.parse(_ctrlTargetLoad.text),
      );
      Navigator.pushReplacementNamed(context, ExerciseMode.route);
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
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'Please enter your\nexercise prescriptions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Georgia',
                  color: colorGoogleGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                label: 'Target Load (kg)',
                controller: _ctrlTargetLoad,
                validator: validateTargetLoad,
                pattern: r'^\d{1,2}(\.\d{0,2})?',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              CustomTextField(
                isPicker: true,
                label: 'Hold time (sec)',
                controller: _ctrlHoldTime,
                validator: validateHoldTime,
              ),
              CustomTextField(
                isPicker: true,
                label: 'Rest time (sec)',
                controller: _ctrlRestTime,
                validator: validateRestTime,
              ),
              CustomTextField(
                label: 'Sets (#)',
                pattern: r'^\d{1,2}',
                controller: _ctrlSets,
                validator: validateSets,
              ),
              CustomTextField(
                label: 'Reps (#)',
                pattern: r'^\d{1,2}',
                controller: _ctrlReps,
                validator: validateReps,
              ),
              CustomTextField(
                isPicker: true,
                controller: _ctrlSetRest,
                label: 'Rest time b/w Sets (sec)',
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                CustomButton(
                  text: const Text('Go'),
                  color: colorGoogleGreen,
                  icon: const Icon(Icons.done_rounded),
                  onPressed: _submit,
                ),
                CustomButton(
                  text: const Text('Clear all'),
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () => _formKey.currentState!.reset(),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
