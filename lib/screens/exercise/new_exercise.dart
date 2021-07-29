import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/custom/custom_time_tile.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key, this.user}) : super(key: key);

  final User? user;
  static const String route = '/newExercise';

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();
  late final Prescription? _lastPre = context.model.settingsState!.lastPrescriptions;
  bool _useLastPrescription = false;

  Duration _mvcTime = const Duration();
  Duration _holdTime = const Duration();
  Duration _restTime = const Duration();
  Duration _setRestTime = const Duration(seconds: 90);

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
    if (kIsWeb) _init(widget.user!.prescription!);
  }

  Future<void> _init(Prescription _pre) async {
    _ctrlTargetLoad.text = _pre.targetLoad.toString();
    _ctrlSets.text = _pre.sets.toString();
    _ctrlReps.text = _pre.reps.toString();
    _mvcTime = Duration(seconds: _pre.mvcDuration);
    _holdTime = Duration(seconds: _pre.holdTime);
    _restTime = Duration(seconds: _pre.restTime);
    _setRestTime = Duration(seconds: _pre.setRest);
  }

  void _clearForm() {
    _ctrlSets.clear();
    _ctrlReps.clear();
    _ctrlTargetLoad.clear();
    _mvcTime = _holdTime = _restTime = const Duration();
    _setRestTime = const Duration(seconds: 90);
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final Prescription _pre = Prescription(
        targetLoad: double.parse(_ctrlTargetLoad.text),
        sets: int.parse(_ctrlSets.text),
        reps: int.parse(_ctrlReps.text),
        holdTime: _holdTime.inSeconds,
        restTime: _restTime.inSeconds,
        setRest: _setRestTime.inSeconds,
        mvcDuration: _mvcTime.inSeconds,
      );
      if (kIsWeb) {
        await widget.user!.prescriptionRef!.update(_pre.toMap()).then(context.pop);
      } else {
        context.model.prescription = _pre;
        context.model.settingsState!.lastPrescriptions = _pre;
        await context.model.settingsState!.save();
        await context.push(ExerciseMode.route, replace: true);
      }
    }
  }

  Future<void> _onChanged(bool value) async {
    if (value) {
      await _init(context.model.settingsState!.lastPrescriptions!);
    } else {
      _clearForm();
    }
    setState(() => _useLastPrescription = value);
  }

  @override
  Widget build(BuildContext context) => kIsWeb ? _buildForm() : _buildScaffold();

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('New Exercise')),
      body: SingleChildScrollView(child: AppFrame(child: _buildForm())),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        if (kIsWeb)
          CustomTimeTile(
            time: _mvcTime,
            desc: 'MVC test duration',
            onChanged: (Duration duration) => setState(() => _mvcTime = duration),
          )
        else ...<Widget>[
          const Text('Please enter your\nexercise prescriptions', style: tsG24BFF, textAlign: TextAlign.center),
          if (_lastPre != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SwitchListTile.adaptive(
                onChanged: _onChanged,
                value: _useLastPrescription,
                activeColor: colorGoogleGreen,
                title: const Text('Use prescriptions from last exercise.'),
              ),
            ),
        ],
        CustomTextField(
          label: 'Target Load (Kg)',
          controller: _ctrlTargetLoad,
          format: r'^\d{1,2}(\.\d{0,2})?',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        Row(children: <Widget>[
          Expanded(child: CustomTextField(label: 'Sets (#)', format: r'^\d{1,2}', controller: _ctrlSets)),
          const VerticalDivider(width: 5),
          Expanded(child: CustomTextField(label: 'Reps (#)', format: r'^\d{1,2}', controller: _ctrlReps)),
        ]),
        CustomTimeTile(
          desc: 'Hold time',
          time: _holdTime,
          onChanged: (Duration duration) => setState(() => _holdTime = duration),
        ),
        const Divider(height: 0),
        CustomTimeTile(
          desc: 'Rest time',
          time: _restTime,
          onChanged: (Duration duration) => setState(() => _restTime = duration),
        ),
        const Divider(height: 0),
        CustomTimeTile(
          desc: 'Set rest time',
          time: _setRestTime,
          onChanged: (Duration duration) => setState(() => _setRestTime = duration),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          CustomButton(
            onPressed: _onSubmit,
            left: const Icon(Icons.done_rounded),
            right: const Text('Submit', style: TextStyle(color: colorGoogleGreen)),
          ),
          CustomButton(
            onPressed: _clearForm,
            right: const Text('Clear'),
            left: const Icon(Icons.clear),
          ),
        ]),
      ]),
    );
  }
}
