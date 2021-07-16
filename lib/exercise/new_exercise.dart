import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/text_styles.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';

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
  final TextEditingController _ctrlHoldTime = TextEditingController();
  final TextEditingController _ctrlRestTime = TextEditingController();
  final TextEditingController _ctrlSetRest = TextEditingController();
  final TextEditingController _ctrlTargetLoad = TextEditingController();
  final TextEditingController _ctrlMVCDuration = TextEditingController();
  late final Prescription? _lastPre = context.model.settingsState!.lastPrescriptions;
  bool _useLastPrescription = false;

  @override
  void dispose() {
    _ctrlSets.dispose();
    _ctrlReps.dispose();
    _ctrlSetRest.dispose();
    _ctrlHoldTime.dispose();
    _ctrlRestTime.dispose();
    _ctrlTargetLoad.dispose();
    _ctrlMVCDuration.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _init(widget.user!.prescription!);
  }

  Future<void> _init(Prescription _pre) async {
    _ctrlSets.text = _pre.sets.toString();
    _ctrlReps.text = _pre.reps.toString();
    _ctrlSetRest.text = _pre.setRest.toString();
    _ctrlHoldTime.text = _pre.holdTime.toString();
    _ctrlRestTime.text = _pre.restTime.toString();
    _ctrlTargetLoad.text = _pre.targetLoad.toString();
    _ctrlMVCDuration.text = _pre.mvcDuration.toString();
  }

  void _clearForm() {
    _ctrlSets.clear();
    _ctrlReps.clear();
    _ctrlSetRest.clear();
    _ctrlHoldTime.clear();
    _ctrlRestTime.clear();
    _ctrlTargetLoad.clear();
    _ctrlMVCDuration.clear();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final Prescription _pre = Prescription(
        sets: int.parse(_ctrlSets.text),
        reps: int.parse(_ctrlReps.text),
        holdTime: int.parse(_ctrlHoldTime.text),
        restTime: int.parse(_ctrlRestTime.text),
        targetLoad: double.parse(_ctrlTargetLoad.text),
        setRest: int.tryParse(_ctrlSetRest.text) ?? 90,
        mvcDuration: int.tryParse(_ctrlMVCDuration.text) ?? 0,
      );
      if (kIsWeb) {
        await widget.user!.prescriptionRef!.update(_pre.toMap()).then(context.pop);
      } else {
        context.model
          ..prescription = _pre
          ..settingsState!.lastPrescriptions = _pre;
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
      appBar: AppBar(title: const Text('New Exercise', textAlign: TextAlign.center)),
      body: SingleChildScrollView(child: AppFrame(child: _buildForm())),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        if (!kIsWeb) ...<Widget>[
          const Text('Please enter your\nexercise prescriptions', textAlign: TextAlign.center, style: tsG18BFF),
          if (_lastPre != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SwitchListTile.adaptive(
                onChanged: _onChanged,
                value: _useLastPrescription,
                title: const Text('Use prescriptions from last exercise.'),
              ),
            ),
        ] else
          CustomTextField(
            isPicker: true,
            validator: validateNum,
            label: 'MVC Test duration',
            controller: _ctrlMVCDuration,
          ),
        CustomTextField(
          label: 'Target Load (Kg)',
          controller: _ctrlTargetLoad,
          validator: validateNum,
          pattern: r'^\d{1,2}(\.\d{0,2})?',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        CustomTextField(
          isPicker: true,
          label: 'Hold time (Sec)',
          controller: _ctrlHoldTime,
          validator: validateNum,
        ),
        CustomTextField(
          isPicker: true,
          label: 'Rest time (Sec)',
          controller: _ctrlRestTime,
          validator: validateNum,
        ),
        CustomTextField(
          label: 'Sets (#)',
          pattern: r'^\d{1,2}',
          controller: _ctrlSets,
          validator: validateNum,
        ),
        CustomTextField(
          label: 'Reps (#)',
          pattern: r'^\d{1,2}',
          controller: _ctrlReps,
          validator: validateNum,
        ),
        CustomTextField(
          isPicker: true,
          controller: _ctrlSetRest,
          label: 'Rest time b/w Sets (default: 90 Sec)',
        ),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          CustomButton(
            onPressed: _submit,
            icon: const Icon(Icons.done_rounded, color: colorGoogleGreen),
            child: const Text('Go', style: TextStyle(color: colorGoogleGreen)),
          ),
          CustomButton(
            onPressed: _clearForm,
            icon: const Icon(Icons.clear_rounded),
            child: const Text('Clear'),
          ),
        ]),
      ]),
    );
  }
}
