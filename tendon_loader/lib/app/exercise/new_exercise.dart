import 'package:flutter/material.dart';
import 'package:tendon_loader/app/mvctest/time_picker_tile.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/input_widget.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/models/prescription.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({
    super.key,
    // required this.readOnly,
    // required this.prescription,
    // required this.onSubmit,
  });

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

  final bool readOnly = true;
  final Prescription prescription = const Prescription.empty();
  void onSubmit() {}

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
        actions: [
          RawButton.tile(
            leading: const Text('OK', style: Styles.titleStyle),
            onTap: _onSubmit,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: IgnorePointer(
          ignoring: readOnly,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: Text(
                    readOnly ? 'Review prescriptions' : 'Select prescriptions',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xff3ddc85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!readOnly)
                  SwitchListTile(
                    value: _useLastPrescription,
                    contentPadding: Styles.tilePadding,
                    title: const Text('Use previous prescriptions'),
                    onChanged: (value) {
                      _usePrevious(value);
                      setState(() => _useLastPrescription = value);
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InputWidget(
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
                  child: Row(children: [
                    Expanded(
                      child: InputWidget(
                        label: 'Sets (#)',
                        format: r'^\d{1,2}',
                        controller: _ctrlSets,
                      ),
                    ),
                    const VerticalDivider(width: 16),
                    Expanded(
                      child: InputWidget(
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
                  onSelected: (duration) =>
                      setState(() => _holdTime = duration),
                ),
                TimePickerTile(
                  time: _restTime,
                  desc: 'Rep rest time',
                  onSelected: (duration) =>
                      setState(() => _restTime = duration),
                ),
                TimePickerTile(
                  time: _setRestTime,
                  desc: 'Set rest time (default: 90 sec)',
                  onSelected: (duration) =>
                      setState(() => _setRestTime = duration),
                ),
                TimePickerTile(
                  time: _mvcDuration,
                  desc: 'MVC test duration (optional)',
                  onSelected: (value) => setState(() => _mvcDuration = value),
                ),
                const SizedBox(height: 20),
                RawButton.tile(
                  leading: const Icon(Icons.refresh, color: Color(0xffff534d)),
                  child: Text(readOnly
                      ? 'Prescriptions are read only!'
                      : 'Reset to default'),
                  onTap: () => setState(() => _clearForm()),
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
    // final Prescription pre = _useLastPrescription
    //     ? AppScope.of(context).userState.prescription
    //     : prescription;
    // _ctrlTargetLoad.text = pre.targetLoad.toString();
    // _ctrlSets.text = pre.sets.toString();
    // _ctrlReps.text = pre.reps.toString();
    // _holdTime = pre.holdTime;
    // _restTime = pre.restTime;
    // _setRestTime = pre.setRest;
    // _mvcDuration = pre.mvcDuration;
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
      if (_holdTime > 0 && _restTime > 0 && _setRestTime > 0) {
        // AppScope.of(context).watch<Prescription>((item) {
        //   return item.copyWith(
        //     targetLoad: double.parse(_ctrlTargetLoad.text),
        //     sets: int.parse(_ctrlSets.text),
        //     reps: int.parse(_ctrlReps.text),
        //     holdTime: _holdTime,
        //     restTime: _restTime,
        //     setRest: _setRestTime,
        //     mvcDuration: _mvcDuration,
        //   );
        // });
        onSubmit();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select time values.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter required fields.')));
    }
  }

  void _usePrevious(bool value) => (value ? _initFields : _clearForm)();
}
