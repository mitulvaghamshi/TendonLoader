import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/settings/settings_model.dart';
import 'package:tendon_loader/settings/settings_handler.dart';
import 'package:tendon_loader/home.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';
import 'package:tendon_loader_lib/utils/validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animCtrl;

  bool _staySignedIn = true;
  bool _isNew = false;
  bool _busy = false;
  String? _oldUser;
  User? _user;

  void _getUser() {
    final Box<Map<dynamic, dynamic>> _loginBox = Hive.box(keyLoginBox);
    if (_loginBox.containsKey(keyLoginBox)) {
      final Map<String, dynamic> _login = Map<String, dynamic>.from(_loginBox.get(keyLoginBox)!);
      setState(() {
        _oldUser = _login[keyOldUserEmail] as String?;
        _staySignedIn = _login[keyKeepLoggedIn] as bool? ?? true;
        if (_staySignedIn) {
          _emailCtrl.text = _login[keyUserEmail] as String? ?? '';
          _passwordCtrl.text = _login[keyPassword] as String? ?? '';
        }
      });
    }
  }

  Future<void> _setUser() async {
    final Box<Map<dynamic, dynamic>> _loginBox = Hive.box(keyLoginBox);
    final Map<String, dynamic> _login = <String, dynamic>{keyKeepLoggedIn: _staySignedIn || _isNew};
    if (_oldUser == null || _oldUser != _emailCtrl.text) {
      await FirebaseFirestore.instance
          .collection(keyAllUsers)
          .doc(_emailCtrl.text)
          .set(<String, dynamic>{'LastActive': DateTime.now()});
    }
    if (_staySignedIn || _isNew) {
      SettingsModel.userId = _emailCtrl.text;
      _login[keyUserEmail] = _emailCtrl.text;
      _login[keyPassword] = _passwordCtrl.text;
      _login[keyOldUserEmail] = _emailCtrl.text;
    }
    await _loginBox.put(keyLoginBox, _login);
    await getSettings();
  }

  Future<void> _authenticate(AnimationStatus status) async {
    if (status == AnimationStatus.forward) {
      if (_formKey.currentState!.validate() && !_busy) {
        _busy = true;
        _user = await authenticate(context, _isNew, _emailCtrl.text, _passwordCtrl.text);
        if (_user != null) await _setUser();
      }
    } else if (status == AnimationStatus.completed) {
      _busy = false;
      if (_user != null) {
        await Navigator.pushReplacementNamed(context, Home.route);
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
      body: SingleChildScrollView(
        child: AppFrame(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const AppLogo(),
                CustomTextField(
                  label: 'Username',
                  hint: 'Enter your username',
                  controller: _emailCtrl,
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  isObscure: true,
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordCtrl,
                  validator: validatePassword,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 10),
                if (!_isNew)
                  ListTile(
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    onTap: () => setState(() => _staySignedIn = !_staySignedIn),
                    title: const Text('Keep me logged in.', style: TextStyle(fontSize: 14)),
                    leading: Icon(
                      _staySignedIn ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                GestureDetector(
                  onTap: () => setState(() => _isNew = !_isNew),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      _isNew ? 'Already have an account? Sign in.' : 'Don\'t have an account? Sign up',
                      style: const TextStyle(letterSpacing: 0.5, color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl),
                    child: CustomFab(
                      fSize: 60,
                      onTap: _animCtrl.forward,
                      icon: _isNew ? Icons.add : Icons.send_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
