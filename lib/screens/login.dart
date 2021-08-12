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
import 'package:tendon_loader/webportal/homepage.dart';

final Map<String, String> _errors = <String, String>{
  'email-already-in-use': 'The account already exists for that email.',
  'invalid-email': 'Invalid email.',
  'weak-password': 'The password is too weak.',
  'wrong-password': 'Invalid password.',
  'user-not-found': 'No user found for that email. Make sure you enter right credentials.',
  'user-disabled': 'This account is disabled.',
  'operation-not-allowed': 'This account is disabled.',
};

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;
  static const String homeRoute = kIsWeb ? HomePage.route : HomeScreen.route;
  // static const String homeRoute = HomePage.route;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  late final UserState? _userState;

  bool _isBusy = false;
  bool _isNew = false;
  bool _isObscure = true;
  bool _keepSigned = true;
  bool _isAdmin = false;

  Future<void> _authenticate() async {
    if (!_isBusy && _formKey.currentState!.validate()) {
      setState(() => _isBusy = true);
      try {
        final UserCredential _credential = await (_isNew
            ? FirebaseAuth.instance.createUserWithEmailAndPassword
            : FirebaseAuth.instance.signInWithEmailAndPassword)(
          email: _emailCtrl.text,
          password: _passwordCtrl.text,
        );
        if (_credential.user != null && await _initUser()) {
          await Future<void>.delayed(const Duration(seconds: 2));
          await context.replace(Login.homeRoute);
        } else if (kIsWeb) {
          setState(() => _isBusy = false);
          if (_isNew && !_isAdmin) {
            context.showSnackBar(const Text('User created successfully!!!'));
          } else {
            context.showSnackBar(const Text('Access denied...', style: tsR20B));
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() => _isBusy = false);
        context.showSnackBar(Text(
          _errors[e.code] ?? 'Unable to reach the internet.',
          style: const TextStyle(color: colorRed400),
        ));
      }
    }
  }

  Future<bool> _initUser() async {
    try {
      _userState!
        ..keepSigned = _keepSigned
        ..userName = _emailCtrl.text
        ..passWord = _passwordCtrl.text;
      if (_userState!.isInBox) {
        await _userState!.save();
      } else {
        await boxUserState.put(keyUserStateBoxItem, _userState!);
      }
      // if (!kIsWeb) {
      late final SettingsState _settingsState;
      if (boxSettingsState.containsKey(_emailCtrl.text.hashCode)) {
        _settingsState = boxSettingsState.get(_emailCtrl.text.hashCode)!;
      } else {
        await boxSettingsState.put(_emailCtrl.text.hashCode, _settingsState = SettingsState());
        await dataStore.doc(_emailCtrl.text).set(Patient(prescription: Prescription.empty()..isAdmin = _isAdmin));
      }
      final Patient _patient = await Patient.of(_emailCtrl.text).fetch();
      _settingsState.toggleCustom(_settingsState.customPrescriptions!, _patient);
      context
        ..patient = _patient
        ..userState = _userState
        ..settingsState = _settingsState;
      // }
      return !kIsWeb || _isAdmin;
    } on Exception {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _userState = boxUserState.get(keyUserStateBoxItem, defaultValue: UserState());
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
        title: Text('Tendon Loader - ${_isNew ? 'Register' : 'Login'}'),
      ),
      body: kIsWeb ? Center(child: SizedBox(width: 350, child: _buildForm())) : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            const CustomImage(),
            CustomTextField(
              label: 'Username',
              controller: _emailCtrl,
              validator: (String? email) {
                if (email == null) return null;
                if (email.isEmpty) {
                  return 'Email can\'t be empty.';
                } else if (!RegExp(emailRegEx).hasMatch(email)) {
                  return 'Enter a correct email address.';
                }
              },
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              label: 'Password',
              isObscure: _isObscure,
              controller: _passwordCtrl,
              validator: (String? password) {
                if (password == null) return null;
                if (password.isEmpty) {
                  return 'Password can\'t be empty.';
                } else if (password.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
              },
              keyboardType: TextInputType.visiblePassword,
              suffix: IconButton(
                onPressed: () => setState(() => _isObscure = !_isObscure),
                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 10),
            if (kIsWeb && _isNew)
              Align(
                alignment: Alignment.bottomLeft,
                child: SwitchListTile.adaptive(
                  value: _isAdmin,
                  activeColor: colorBlue,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mark as clinician'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (_) => setState(() => _isAdmin = !_isAdmin),
                ),
              )
            else
              CheckboxListTile(
                value: _keepSigned,
                activeColor: colorBlue,
                contentPadding: EdgeInsets.zero,
                title: const Text('Keep me logged in.'),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (_) => setState(() => _keepSigned = !_keepSigned),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FittedBox(
                child: CustomButton(
                  onPressed: () => setState(() => _isNew = !_isNew),
                  left: Icon(_isNew ? Icons.check : Icons.add),
                  right: Text(
                    _isNew ? 'Already have an account? Sign in.' : 'Don\'t have an account? Sign up.',
                    style: const TextStyle(letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                rounded: true,
                onPressed: () => Future<void>.microtask(_authenticate),
                left: _isBusy ? const CircularProgressIndicator.adaptive() : Icon(_isNew ? Icons.add : Icons.send),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
