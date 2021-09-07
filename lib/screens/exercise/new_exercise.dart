/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/form_text_field.dart';
import 'package:tendon_loader/custom/time_picker_tile.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key, this.user}) : super(key: key);

  final Patient? user;
  static const String route = '/newExercise';

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();
  late final Prescription? _lastPre = settingsState.prescription;
  bool _useLastPrescription = false;

  int _mvcDuration = 0;
  int _holdTime = 0;
  int _restTime = 0;
  int _setRestTime = 90;

  @override
  void dispose() {
    _ctrlSets.dispose();
    _ctrlReps.dispose();
    _ctrlTargetLoad.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _initWith(widget.user!.prescription!);
  }

  Future<void> _initWith(Prescription _pre) async {
    _ctrlTargetLoad.text = _pre.targetLoad.toString();
    _ctrlSets.text = _pre.sets.toString();
    _ctrlReps.text = _pre.reps.toString();
    _holdTime = _pre.holdTime;
    _restTime = _pre.restTime;
    _setRestTime = _pre.setRest;
    _mvcDuration = _pre.mvcDuration;
  }

  void _clearForm() {
    _ctrlSets.clear();
    _ctrlReps.clear();
    _ctrlTargetLoad.clear();
    _setRestTime = 90;
    _mvcDuration = _holdTime = _restTime = 0;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final Prescription _pre = Prescription(
        targetLoad: double.parse(_ctrlTargetLoad.text),
        sets: int.parse(_ctrlSets.text),
        reps: int.parse(_ctrlReps.text),
        holdTime: _holdTime,
        restTime: _restTime,
        setRest: _setRestTime,
        mvcDuration: _mvcDuration,
      );
      if (kIsWeb) {
        await widget.user!.prescriptionRef!
            .update(_pre.toMap())
            .then(context.pop);
      } else if (_holdTime > 0 && _restTime > 0 && _setRestTime > 0) {
        settingsState.prescription = _pre;
        await settingsState.save();
        await context.replace(ExerciseMode.route);
      } else {
        context.showSnackBar(const Text('Please select time values.'));
      }
    }
  }

  Future<void> _onChanged(bool value) async {
    if (value) {
      await _initWith(settingsState.prescription!);
    } else {
      _clearForm();
    }
    setState(() => _useLastPrescription = value);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildBody() : _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('New Exercise')),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (kIsWeb)
                TimePickerTile(
                  time: _mvcDuration,
                  desc: 'MVC test duration',
                  title: 'Select test duration',
                  onChanged: (int duration) {
                    setState(() => _mvcDuration = duration);
                  },
                )
              else ...<Widget>[
                const Text(
                  'Please enter your\nexercise prescriptions',
                  textAlign: TextAlign.center,
                  style: tsG24B,
                ),
                if (_lastPre != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SwitchListTile.adaptive(
                      onChanged: _onChanged,
                      activeColor: colorIconBlue,
                      value: _useLastPrescription,
                      title: const Text(
                        'Use prescriptions '
                        'from last exercise.',
                      ),
                    ),
                  ),
              ],
              FormTextField(
                label: 'Target Load (Kg)',
                controller: _ctrlTargetLoad,
                format: r'^\d{1,2}(\.\d{0,2})?',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: FormTextField(
                    label: 'Sets (#)',
                    format: r'^\d{1,2}',
                    controller: _ctrlSets,
                  ),
                ),
                const VerticalDivider(width: 5),
                Expanded(
                  child: FormTextField(
                    label: 'Reps (#)',
                    format: r'^\d{1,2}',
                    controller: _ctrlReps,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              TimePickerTile(
                time: _holdTime,
                desc: 'Rep hold time',
                title: 'Select rep hold time',
                onChanged: (int duration) {
                  setState(() => _holdTime = duration);
                },
              ),
              TimePickerTile(
                time: _restTime,
                desc: 'Rep rest time',
                title: 'Select rep rest time',
                onChanged: (int duration) {
                  setState(() => _restTime = duration);
                },
              ),
              TimePickerTile(
                time: _setRestTime,
                desc: 'Set rest time (default: 90 sec)',
                title: 'Select set rest time',
                onChanged: (int duration) {
                  setState(() => _setRestTime = duration);
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomButton(
                    onPressed: _onSubmit,
                    right: const Text('Submit'),
                    left: const Icon(Icons.done),
                  ),
                  CustomButton(
                    onPressed: _clearForm,
                    right: const Text('Clear'),
                    left: const Icon(Icons.clear, color: colorErrorRed),
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
