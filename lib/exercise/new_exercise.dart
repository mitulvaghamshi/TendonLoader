import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/user.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb) _init();
  }

  Future<void> _init() async {
    final Prescription _pre = widget.user!.prescription!;
    _ctrlSets.text = _pre.sets.toString();
    _ctrlReps.text = _pre.reps.toString();
    _ctrlHoldTime.text = _pre.holdTime.toString();
    _ctrlRestTime.text = _pre.restTime.toString();
    _ctrlTargetLoad.text = _pre.targetLoad.toString();
    _ctrlSetRest.text = _pre.setRest.toString();
    _ctrlMVCDuration.text = _pre.mvcDuration.toString();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final Prescription _pre = Prescription(
        sets: int.parse(_ctrlSets.text),
        reps: int.parse(_ctrlReps.text),
        holdTime: int.parse(_ctrlHoldTime.text),
        restTime: int.parse(_ctrlRestTime.text),
        setRest: int.parse(_ctrlSetRest.text),
        targetLoad: double.parse(_ctrlTargetLoad.text),
        mvcDuration: int.tryParse(_ctrlMVCDuration.text) ?? 0,
      );
      if (kIsWeb) {
        await widget.user!.prescriptionRef!.update(_pre.toMap());
        Navigator.pop(context);
      } else {
        AppStateScope.of(context).prescription = _pre;
        await Navigator.pushReplacementNamed(context, ExerciseMode.route);
      }
    }
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
        Text(
          kIsWeb ? 'Please enter prescriptions for:\n${widget.user!.id}' : 'Please enter your\nexercise prescriptions',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Georgia',
            color: googleGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (kIsWeb)
          CustomTextField(
            isPicker: true,
            label: 'MVC Test duration',
            controller: _ctrlMVCDuration,
            validator: validateNum,
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
            icon: const Icon(Icons.done_rounded, color: googleGreen),
            child: const Text('Go', style: TextStyle(color: googleGreen)),
          ),
          CustomButton(
            onPressed: () => _formKey.currentState!.reset(),
            icon: const Icon(Icons.clear_rounded),
            child: const Text('Clear'),
          ),
        ]),
      ]),
    );
  }
}