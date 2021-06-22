import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/modal/prescription.dart';

class NewPrescription extends StatefulWidget {
  const NewPrescription({Key? key}) : super(key: key);

  @override
  _NewPrescriptionState createState() => _NewPrescriptionState();
}

class _NewPrescriptionState extends State<NewPrescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlSets = TextEditingController();
  final TextEditingController _ctrlReps = TextEditingController();
  final TextEditingController _ctrlHoldTime = TextEditingController();
  final TextEditingController _ctrlRestTime = TextEditingController();
  final TextEditingController _ctrlSetRest = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();
  final TextEditingController _ctrlMVCDuration = TextEditingController();

  @override
  void dispose() {
    _ctrlSets.dispose();
    _ctrlReps.dispose();
    _ctrlHoldTime.dispose();
    _ctrlRestTime.dispose();
    _ctrlTargetLoad.dispose();
    _ctrlSetRest.dispose();
    _ctrlMVCDuration.dispose();
    super.dispose();
  }

  Future<void> init() async {
    final Prescription prescription = AppStateScope.of(context).prescription!;
    _ctrlSets.text = prescription.sets.toString();
    _ctrlReps.text = prescription.reps.toString();
    _ctrlHoldTime.text = prescription.holdTime.toString();
    _ctrlRestTime.text = prescription.restTime.toString();
    _ctrlTargetLoad.text = prescription.targetLoad.toString();
    _ctrlSetRest.text = prescription.setRest.toString();
    _ctrlMVCDuration.text = prescription.mvcDuration.toString();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, num> map = Prescription(
        sets: int.parse(_ctrlSets.text),
        reps: int.parse(_ctrlReps.text),
        holdTime: int.parse(_ctrlHoldTime.text),
        restTime: int.parse(_ctrlRestTime.text),
        setRest: int.parse(_ctrlSetRest.text),
        targetLoad: double.parse(_ctrlTargetLoad.text),
        mvcDuration: int.tryParse(_ctrlMVCDuration.text),
      ).toMap();
      await AppStateScope.of(context).currentUser.prescriptionRef.update(map);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Please enter new prescriptions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor.withOpacity(0.8),
            ),
          ),
          CustomTextField(
            isPicker: true,
            label: 'MVC Test duration',
            controller: _ctrlMVCDuration,
            pattern: r'^\d{1,2}(\.\d{0,2})?',
          ),
          const Divider(thickness: 1),
          CustomTextField(
            label: 'Target Load (kg)',
            controller: _ctrlTargetLoad,
            pattern: r'^\d{1,2}(\.\d{0,2})?',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          CustomTextField(
            isPicker: true,
            label: 'Hold time (sec)',
            controller: _ctrlHoldTime,
          ),
          CustomTextField(
            isPicker: true,
            label: 'Rest time (sec)',
            controller: _ctrlRestTime,
          ),
          CustomTextField(
            label: 'Sets (#)',
            controller: _ctrlSets,
            pattern: r'^\d{1,2}',
          ),
          CustomTextField(
            label: 'Reps (#)',
            controller: _ctrlReps,
            pattern: r'^\d{1,2}',
          ),
          CustomTextField(
            isPicker: true,
            label: 'Rest time b/w Sets (sec)',
            controller: _ctrlSetRest,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomButton(
                text: const Text('Save'),
                icon: const Icon(Icons.done_rounded),
                color: const Color.fromRGBO(61, 220, 132, 1),
                onPressed: _submit,
              ),
              CustomButton(
                text: const Text('Clear all'),
                icon: const Icon(Icons.clear_rounded),
                onPressed: () => _formKey.currentState!.reset(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
