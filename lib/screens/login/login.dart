import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';
import 'package:tendon_loader/web/homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;
  static const String homeRoute = kIsWeb ? HomePage.route : HomeScreen.route;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  UserState? _userState;

  bool _isBusy = false;
  bool _isObscure = true;
  bool _keepSigned = true;
  bool _isRegister = false;

  Future<void> _authenticate() async {
    setState(() => _isBusy = true);
    try {
      late final UserCredential _credential;
      if (_isRegister) {
        _credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailCtrl.text, password: _passwordCtrl.text);
      } else {
        _credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailCtrl.text, password: _passwordCtrl.text);
      }
      if (_credential.user != null) {
        _userState!
          ..keepSigned = _keepSigned
          ..userName = _emailCtrl.text
          ..passWord = _passwordCtrl.text;
        if (_userState!.isInBox) {
          await _userState!.save();
        } else {
          await boxUserState.put(keyUserStateBoxItem, _userState!);
        }
        final SettingsState _settingsState = boxSettingsState
            .get(_emailCtrl.text, defaultValue: SettingsState())!;
        if (!_settingsState.isInBox) {
          await boxSettingsState.put(_emailCtrl.text, _settingsState);
          await dbRoot.doc(_emailCtrl.text).get().then(
            (DocumentSnapshot<Patient> patient) async {
              if (!patient.exists) {
                await dbRoot
                    .doc(_emailCtrl.text)
                    .set(Patient(prescription: Prescription.empty()));
              }
            },
          );
        }
        Patient? _patientAsUser = Patient.of(_emailCtrl.text);
        if (!kIsWeb) {
          _patientAsUser = await _patientAsUser.fetch();
          _settingsState.toggle(
            _settingsState.customPrescriptions!,
            _patientAsUser.prescription!,
          );
        }
        context
          ..patient = _patientAsUser
          ..userState = _userState
          ..settingsState = _settingsState;
        await Future<void>.delayed(const Duration(seconds: 2), () async {
          await context.replace(Login.homeRoute);
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isBusy = false);
      context.showSnackBar(Text(
        firebaseErrors[e.code] ?? 'Unable to reach the internet.',
        style: const TextStyle(color: colorRed400),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _userState = boxUserState.get(
      keyUserStateBoxItem,
      defaultValue: UserState(),
    );
    if (_userState != null && (_keepSigned = _userState!.keepSigned!)) {
      _emailCtrl.text = _userState!.userName!;
      _passwordCtrl.text = _userState!.passWord!;
    } else {
      _keepSigned = true;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tendon Loader'),
      ),
      body: kIsWeb
          ? Center(child: SizedBox(width: 350, child: _buildBody()))
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            const CustomImage(),
            CustomTextField(
              label: 'Username',
              controller: _emailCtrl,
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              label: 'Password',
              isObscure: _isObscure,
              validator: validatePass,
              controller: _passwordCtrl,
              keyboardType: TextInputType.visiblePassword,
              suffix: IconButton(
                onPressed: () => setState(() => _isObscure = !_isObscure),
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: _keepSigned,
              activeColor: colorBlue,
              contentPadding: EdgeInsets.zero,
              title: const Text('Keep me logged in.'),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (_) => setState(() => _keepSigned = !_keepSigned),
            ),
            if (!kIsWeb)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FittedBox(
                  child: CustomButton(
                    onPressed: () => setState(() => _isRegister = !_isRegister),
                    left: Icon(_isRegister ? Icons.check : Icons.add),
                    right: Text(
                      _isRegister
                          ? 'Already have an account? Sign in.'
                          : 'Don\'t have an account? Sign up.',
                      style: const TextStyle(letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                rounded: true,
                onPressed: _authenticate,
                left: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: _isBusy
                      ? const CircularProgressIndicator.adaptive()
                      : Icon(_isRegister ? Icons.add : Icons.send),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
