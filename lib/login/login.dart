import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/colors.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/constants/others.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/handler/app_auth.dart';
import 'package:tendon_loader/utils/validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = '/login';
  static const String homeRoute = '/home';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animCtrl;

  bool _result = false;
  bool _isNew = false;
  bool _keepSigned = true;

  void _getUser() {
    final Box<Map<dynamic, dynamic>> _loginBox = Hive.box(keyLoginBox);
    if (_loginBox.containsKey(keyLoginBox)) {
      final Map<String, dynamic> _login = Map<String, dynamic>.from(_loginBox.get(keyLoginBox)!);
      setState(() {
        _keepSigned = _login[keyKeepLoggedIn] as bool? ?? true;
        if (_keepSigned) {
          _emailCtrl.text = _login[keyUsername] as String? ?? '';
          _passwordCtrl.text = _login[keyPassword] as String? ?? '';
        }
      });
    }
  }

  Future<void> _setUser() async {
    final Map<String, dynamic> _login = <String, dynamic>{keyKeepLoggedIn: _keepSigned};
    if (_keepSigned) {
      _login[keyUsername] = _emailCtrl.text;
      _login[keyPassword] = _passwordCtrl.text;
    }
    await Hive.box<Map<dynamic, dynamic>>(keyLoginBox).put(keyLoginBox, _login);
    await AppStateScope.of(context).initUser(_emailCtrl.text);
  }

  Future<void> _authenticate(AnimationStatus status) async {
    if (status == AnimationStatus.forward) {
      if (_formKey.currentState!.validate()) {
        _result = await authenticate(context, _isNew, _emailCtrl.text, _passwordCtrl.text);
        if (_result) await _setUser();
      }
    } else if (status == AnimationStatus.completed) {
      if (_result) {
        await Navigator.pushReplacementNamed(context, Login.homeRoute);
      } else {
        await _animCtrl.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener(_authenticate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppStateScope.of(context).initAppSettings();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tendon Loader - ${_isNew ? 'Register' : 'Login'}')),
      body: kIsWeb ? Center(child: SizedBox(width: sizeleftPanel, child: _buildLoginBody())) : _buildLoginBody(),
    );
  }

  Widget _buildLoginBody() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            const AppLogo(),
            CustomTextField(
              label: 'Username',
              controller: _emailCtrl,
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              isObscure: true,
              label: 'Password',
              controller: _passwordCtrl,
              validator: validatePassword,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 10),
            ListTile(
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              onTap: () => setState(() => _keepSigned = !_keepSigned),
              title: const Text('Keep me signed in.', style: TextStyle(fontSize: 14)),
              leading: Icon(
                _keepSigned ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                color: Theme.of(context).accentColor,
              ),
            ),
            ElevatedButton(
              onPressed: () => setState(() => _isNew = !_isNew),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(20)),
              ),
              child: Text(
                _isNew ? 'Already have an account? Sign in.' : 'Don\'t have an account? Sign up.',
                style: const TextStyle(letterSpacing: 0.5, color: colorGoogleGreen),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: RotationTransition(
                turns: Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl),
                child: CustomButton(
                  onPressed: _animCtrl.forward,
                  icon: Icon(_isNew ? Icons.add : Icons.send_rounded),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
