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
  const Login({Key? key, this.isRegister = false}) : super(key: key);

  final bool isRegister;
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
              style: TextStyle(color: colorRed400),
            ));
          } else {
            patient = _patientAsUser;
            userState = _userState;
            settingsState = _settingsState;
            await Future<void>.delayed(const Duration(seconds: 2), () async {
              await context.replace(Login.homeRoute);
            });
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isBusy = false);
      context.showSnackBar(Text(
        firebaseErrors[e.code] ?? 'Unable to reach the internet.',
        style: const TextStyle(color: colorRed400),
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
    return widget.isRegister ? _buildBody() : _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader')),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              return constraints.isSatisfiedBy(const Size(900, 1000))
                  ? _buildHorizontalLayout()
                  : _buildVerticalLayout();
            },
          ),
        ),
      ),
    );
  }

  Column _buildVerticalLayout() {
    return Column(children: <Widget>[
      const CustomImage(),
      ..._buildFormItems(),
    ]);
  }

  Row _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.longestSide * 0.4,
          child: const AspectRatio(
            aspectRatio: 1,
            child: CustomImage(),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.longestSide * 0.3,
          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildFormItems(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFormItems() {
    return <Widget>[
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
      if (widget.isRegister)
        SwitchListTile.adaptive(
          value: _isAdmin,
          activeColor: colorBlue,
          contentPadding: EdgeInsets.zero,
          title: const Text('Allow web portal access'),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (_) => setState(() => _isAdmin = !_isAdmin),
        )
      else
        CheckboxListTile(
          value: _keepSigned,
          activeColor: colorBlue,
          contentPadding: EdgeInsets.zero,
          title: const Text('Keep me signed in.'),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (_) => setState(() => _keepSigned = !_keepSigned),
        ),
      if (!kIsWeb)
        FittedBox(
          child: CustomButton(
            onPressed: () => setState(() {
              _isRegister = !_isRegister;
            }),
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
    ];
  }
}
