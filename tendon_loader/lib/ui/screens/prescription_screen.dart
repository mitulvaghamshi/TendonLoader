import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/ui/widgets/input_field.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/ui/widgets/time_picker_tile.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key, required this.prescription});

  final Prescription prescription;

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  late final state = AppScope.of(context);
  late final pre = widget.prescription;

  late final _loadCtrl = TextEditingController()
    ..text = pre.targetLoad.toString();
  late final _setsCtrl = TextEditingController()..text = pre.sets.toString();
  late final _repsCtrl = TextEditingController()..text = pre.reps.toString();

  late int _holdTime = pre.holdTime;
  late int _restTime = pre.restTime;
  late int _setRestTime = pre.setRest;
  late int _mvcDuration = pre.mvcDuration;

  @override
  void dispose() {
    _loadCtrl.dispose();
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: state,
        child: RawButton.tile(
          spacing: 16,
          leading: RawButton(
            onTap: () => setState(_reset),
            color: Colors.indigo,
            child: const Text('Reset', style: Styles.whiteBold),
          ),
          child: Expanded(
            child: RawButton(
              onTap: _onSubmit,
              color: Colors.green,
              child: const Text('Save and exit', style: Styles.whiteBold),
            ),
          ),
        ),
        builder: (_, child) => Column(children: [
          SwitchListTile(
            contentPadding: Styles.tilePadding,
            title: const Text('Use custom prescriptions'),
            subtitle: const Text('Create your own prescriptions.'),
            value: state.settings.editablePrescription,
            onChanged: (value) => state.update<Settings>((settings) {
              return settings.copyWith(editablePrescription: value);
            }),
          ),
          const Divider(),
          IgnorePointer(
            ignoring: !state.settings.editablePrescription,
            child: Column(children: [
              InputField.form(
                controller: _loadCtrl,
                label: 'Target Load (Kg)',
                format: r'^\d{1,2}(\.\d{0,2})?',
                padding: Styles.tilePadding,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              Row(children: [
                Expanded(
                  child: InputField.form(
                    controller: _setsCtrl,
                    label: 'Sets (#)',
                    format: r'^\d{1,2}',
                    padding: Styles.tilePadding,
                  ),
                ),
                Expanded(
                  child: InputField.form(
                    controller: _repsCtrl,
                    label: 'Reps (#)',
                    format: r'^\d{1,2}',
                    padding: Styles.tilePadding,
                  ),
                ),
              ]),
              TimePickerTile(
                time: _holdTime,
                label: 'Rep hold time',
                onPick: (time) => setState(() => _holdTime = time),
              ),
              TimePickerTile(
                time: _restTime,
                label: 'Rep rest time',
                onPick: (time) => setState(() => _restTime = time),
              ),
              TimePickerTile(
                time: _setRestTime,
                label: 'Set rest time (default: 90 sec)',
                onPick: (time) => setState(() => _setRestTime = time),
              ),
              TimePickerTile(
                time: _mvcDuration,
                label: 'MVC test duration (optional)',
                onPick: (time) => setState(() => _mvcDuration = time),
              ),
              const Divider(),
              child!,
            ]),
          ),
        ]),
      ),
    );
  }
}

extension on _PrescriptionScreenState {
  void _reset() {
    _loadCtrl.clear();
    _setsCtrl.clear();
    _repsCtrl.clear();
    _mvcDuration = _holdTime = _restTime = 0;
    _setRestTime = 90;
  }

  void _onSubmit() {
    final targetLoad = double.tryParse(_loadCtrl.text) ?? 0;
    final sets = int.tryParse(_setsCtrl.text) ?? 0;
    final reps = int.tryParse(_repsCtrl.text) ?? 0;

    late final String error;
    if (targetLoad <= 0) {
      error = 'Please enter Target Load';
    } else if (sets <= 0) {
      error = 'Please enter number of Sets';
    } else if (reps <= 0) {
      error = 'Please enter number of Reps';
    } else if (_holdTime <= 0) {
      error = 'Please select Rep hold time';
    } else if (_restTime <= 0) {
      error = 'Please select Rep rest time';
    } else if (_setRestTime <= 0) {
      error = 'Please select Set rest time';
    } else {
      AppScope.of(context).update<Prescription>((item) {
        return item.copyWith(
          targetLoad: targetLoad,
          sets: sets,
          reps: reps,
          holdTime: _holdTime,
          restTime: _restTime,
          setRest: _setRestTime,
          mvcDuration: _mvcDuration,
        );
      });
      return context.pop();
    }
    final snackBar = SnackBar(
      padding: EdgeInsets.zero,
      content: RawButton.error(message: error),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
