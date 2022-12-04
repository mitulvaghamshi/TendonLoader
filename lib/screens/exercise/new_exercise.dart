import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/models/prescription.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/screens/mvctest/widgets/time_picker_tile.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/settings/models/settings.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({
    super.key,
    required this.readOnly,
    required this.prescription,
    required this.onSubmit,
  });

  final bool readOnly;
  final Prescription prescription;
  final void Function(Prescription) onSubmit;

  @override
  NewExerciseState createState() => NewExerciseState();
}

class NewExerciseState extends State<NewExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('New Exercise'),
        actions: <Widget>[
          CustomWidget.two(
            left: const Text('OK', style: Styles.titleStyle),
            right: const Icon(Icons.arrow_forward),
            onPressed: _onSubmit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: IgnorePointer(
          ignoring: widget.readOnly,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: Text(
                    widget.readOnly
                        ? 'Review prescriptions'
                        : 'Select prescriptions',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xff3ddc85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!widget.readOnly)
                  SwitchListTile(
                    value: _useLastPrescription,
                    contentPadding: Styles.tilePadding,
                    title: const Text('Use previous prescriptions'),
                    onChanged: (bool value) {
                      _usePrevious(value);
                      setState(() => _useLastPrescription = value);
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InputWidget(
                    label: 'Target Load (Kg)',
                    controller: _ctrlTargetLoad,
                    format: r'^\d{1,2}(\.\d{0,2})?',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: _InputWidget(
                        label: 'Sets (#)',
                        format: r'^\d{1,2}',
                        controller: _ctrlSets,
                      ),
                    ),
                    const VerticalDivider(width: 16),
                    Expanded(
                      child: _InputWidget(
                        label: 'Reps (#)',
                        format: r'^\d{1,2}',
                        controller: _ctrlReps,
                      ),
                    ),
                  ]),
                ),
                TimePickerTile(
                  time: _holdTime,
                  desc: 'Rep hold time',
                  onSelected: (int duration) =>
                      setState(() => _holdTime = duration),
                ),
                TimePickerTile(
                  time: _restTime,
                  desc: 'Rep rest time',
                  onSelected: (int duration) =>
                      setState(() => _restTime = duration),
                ),
                TimePickerTile(
                  time: _setRestTime,
                  desc: 'Set rest time (default: 90 sec)',
                  onSelected: (int duration) =>
                      setState(() => _setRestTime = duration),
                ),
                TimePickerTile(
                  time: _mvcDuration,
                  desc: 'MVC test duration (optional)',
                  onSelected: (int value) =>
                      setState(() => _mvcDuration = value),
                ),
                const SizedBox(height: 20),
                CustomWidget.two(
                  left: const Icon(Icons.refresh, color: Color(0xffff534d)),
                  right: Text(widget.readOnly
                      ? 'Prescriptions are read only!'
                      : 'Reset to default'),
                  onPressed: () => setState(() => _clearForm()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on NewExerciseState {
  void _initFields() {
    final Prescription pre = _useLastPrescription
        ? AppState.of(context).getLastPrescription()
        : widget.prescription;
    _ctrlTargetLoad.text = pre.targetLoad.toString();
    _ctrlSets.text = pre.sets.toString();
    _ctrlReps.text = pre.reps.toString();
    _holdTime = pre.holdTime;
    _restTime = pre.restTime;
    _setRestTime = pre.setRest;
    _mvcDuration = pre.mvcDuration;
  }

  void _clearForm() {
    _ctrlSets.clear();
    _ctrlReps.clear();
    _ctrlTargetLoad.clear();
    _mvcDuration = _holdTime = _restTime = 0;
    _setRestTime = 90;
    _useLastPrescription = false;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final Prescription pre = widget.prescription
        ..copyWith(
          targetLoad: double.parse(_ctrlTargetLoad.text),
          sets: int.parse(_ctrlSets.text),
          reps: int.parse(_ctrlReps.text),
          holdTime: _holdTime,
          restTime: _restTime,
          setRest: _setRestTime,
          mvcDuration: _mvcDuration,
        );
      if (_holdTime > 0 && _restTime > 0 && _setRestTime > 0) {
        AppState.of(context).settings((Settings settings) {
          settings.prescription = pre;
        });
        widget.onSubmit(pre);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select time values.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter required fields.')));
    }
  }

  void _usePrevious(bool value) {
    if (value) {
      _initFields();
    } else {
      _clearForm();
    }
  }
}

class _InputWidget extends StatelessWidget {
  const _InputWidget({
    this.label,
    this.format,
    this.controller,
    this.keyboardType,
  });

  final String? label;
  final String? format;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Styles.titleStyle,
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: <TextInputFormatter>[
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format!)),
      ],
      validator: (String? value) =>
          value == null || value.isEmpty ? '$label is required' : null,
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
