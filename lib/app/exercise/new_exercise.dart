import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/widgets/time_picker_tile.dart';
import 'package:tendon_loader/shared/models/patient.dart';
import 'package:tendon_loader/shared/models/prescription.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/shared/widgets/frame_widget.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key, this.user}) : super(key: key);

  final Patient? user;

  static const String route = '/newexercise';

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
      appBar: AppBar(
        elevation: 0,
        title: const Text('New Exercise'),
      ),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: FrameWidget(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff3ddc85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_lastPre != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SwitchListTile.adaptive(
                        onChanged: _onChanged,
                        value: _useLastPrescription,
                        title: const Text(
                          'Use prescriptions '
                          'from last exercise.',
                        ),
                      ),
                    ),
                ],
                _InputWidget(
                  label: 'Target Load (Kg)',
                  controller: _ctrlTargetLoad,
                  format: r'^\d{1,2}(\.\d{0,2})?',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                Row(children: <Widget>[
                  Expanded(
                    child: _InputWidget(
                      label: 'Sets (#)',
                      format: r'^\d{1,2}',
                      controller: _ctrlSets,
                    ),
                  ),
                  const VerticalDivider(width: 5),
                  Expanded(
                    child: _InputWidget(
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
                    ButtonWidget(
                      onPressed: _onSubmit,
                      right: const Text('Submit'),
                      left: const Icon(
                        Icons.done,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                    ButtonWidget(
                      onPressed: _clearForm,
                      right: const Text('Clear'),
                      left: const Icon(Icons.clear, color: Color(0xffff534d)),
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

class _InputWidget extends StatelessWidget {
  const _InputWidget({
    Key? key,
    this.label,
    this.format,
    this.controller,
    this.keyboardType,
  }) : super(key: key);

  final String? label;
  final String? format;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      inputFormatters: <TextInputFormatter>[
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format!)),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffix: IconButton(
          onPressed: controller!.clear,
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }
}
