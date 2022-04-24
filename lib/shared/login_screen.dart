import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app/homescreen.dart';
import 'package:tendon_loader/shared/models/patient.dart';
import 'package:tendon_loader/shared/models/prescription.dart';
import 'package:tendon_loader/shared/models/settings_state.dart';
import 'package:tendon_loader/shared/models/user_state.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/app_logo.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/web/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.isRegister = false}) : super(key: key);

  final bool isRegister;

  static const String route = Navigator.defaultRouteName;
  static const String homeRoute = kIsWeb ? HomePage.route : HomeScreen.route;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  UserState? _userState;

  bool _isBusy = false;
  bool _isObscure = true;
  bool _keepSigned = true;
  bool _isAdmin = false;
  bool _isRegister = false;

  Future<void> _authenticate() async {
    setState(() => _isBusy = true);
    try {
      late final UserCredential _credential;
      if (_isRegister || (kIsWeb && widget.isRegister)) {
        _credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailCtrl.text, password: _passwordCtrl.text);
      } else {
        _credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailCtrl.text, password: _passwordCtrl.text);
      }
      if (widget.isRegister) {
        if (_credential.user != null) await _createUserEntry();
        setState(() => _isBusy = false);
        context.showSnackBar(const Text('User created successfully!'));
        _emailCtrl.clear();
        _passwordCtrl.clear();
      } else {
        if (_credential.user != null) {
          _userState!
            ..keepSigned = _keepSigned
            ..userName = _emailCtrl.text
            ..passWord = _passwordCtrl.text;
          if (_userState!.isInBox) {
            await _userState!.save();
          } else {
            await boxUserState.put(keyUserStateBox, _userState!);
          }
          final SettingsState _settingsState = boxSettingsState
              .get(_emailCtrl.text, defaultValue: SettingsState())!;
          if (!_settingsState.isInBox) {
            await boxSettingsState.put(_emailCtrl.text, _settingsState);
            await _createUserEntry();
          }
          try {
            final Patient _patientAsUser =
                await Patient.of(_emailCtrl.text).fetch();
            if (!kIsWeb) {
              _settingsState.toggle(
                _settingsState.customPrescriptions!,
                _patientAsUser.prescription!,
              );
            }
            if (kIsWeb && !_patientAsUser.prescription!.isAdmin!) {
              setState(() => _isBusy = false);
              context.showSnackBar(const Text(
                'Are you a clinician?',
                style: TextStyle(color: Color(0xffff534d)),
              ));
            } else {
              patient = _patientAsUser;
              userState = _userState;
              settingsState = _settingsState;
              await Future<void>.delayed(const Duration(seconds: 2), () async {
                await context.replace(LoginScreen.homeRoute);
              });
            }
          } on Exception {
            setState(() => _isBusy = false);
            context.showSnackBar(const Text(
              'Opps! Something want wrong, please contact your developer...',
              style: TextStyle(color: Color(0xffff534d)),
            ));
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isBusy = false);
      context.showSnackBar(Text(
        firebaseErrors[e.code] ?? 'Unable to reach the internet.',
        style: const TextStyle(color: Color(0xffff534d)),
      ));
    }
  }

  Future<void> _createUserEntry() async {
    await dbRoot.doc(_emailCtrl.text).get().then(
      (DocumentSnapshot<Patient> patient) async {
        if (!patient.exists) {
          await dbRoot.doc(_emailCtrl.text).set(Patient(
                prescription: Prescription.empty()..isAdmin = _isAdmin,
              ));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isRegister) {
      _userState = boxUserState.get(
        keyUserStateBox,
        defaultValue: UserState(),
      );
      if (_userState != null && (_keepSigned = _userState!.keepSigned!)) {
        _emailCtrl.text = _userState!.userName!;
        _passwordCtrl.text = _userState!.passWord!;
      } else {
        _keepSigned = true;
      }
    } else {
      _userState = UserState();
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
    return widget.isRegister
        ? _buildBody()
        : Scaffold(body: Center(child: _buildBody()));
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const AppLogo(),
            SizedBox(width: 400, child: _buildForm()),
          ],
        ),
      ),
    );
  }

  Column _buildForm() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: 'Username',
            suffix: IconButton(
              onPressed: _emailCtrl.clear,
              icon: const Icon(Icons.clear),
            ),
          ),
          validator: (String? value) {
            if (value == null) return null;
            if (value.isEmpty) {
              return 'Email can\'t be empty.';
            } else if (!RegExp(emailRegEx).hasMatch(value)) {
              return 'Enter a correct email address.';
            }
            return null;
          },
        ),
        TextFormField(
          obscureText: _isObscure,
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: 'Password',
            suffix: IconButton(
              onPressed: () => setState(() => _isObscure = !_isObscure),
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          validator: (String? value) {
            if (value == null) return null;
            if (value.isEmpty) {
              return 'Password can\'t be empty.';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters long.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        if (widget.isRegister)
          SwitchListTile.adaptive(
            value: _isAdmin,
            contentPadding: EdgeInsets.zero,
            title: const Text('Allow web portal access'),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) => setState(() => _isAdmin = !_isAdmin),
          )
        else
          CheckboxListTile(
            value: _keepSigned,
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF007AFF),
            title: const Text('Keep me signed in.'),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) => setState(() => _keepSigned = !_keepSigned),
          ),
        if (!kIsWeb)
          FittedBox(
            child: ButtonWidget(
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
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.bottomRight,
          child: ButtonWidget(
            onPressed: _authenticate,
            left: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: _isBusy
                  ? const CircularProgressIndicator.adaptive()
                  : Icon(_isRegister ? Icons.add : Icons.send),
            ),
          ),
        ),
      ],
    );
  }
}
