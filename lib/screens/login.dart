import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart' show Key, kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Box, Hive;
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_fab.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/handler/app_auth.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

mixin ValidateCredential {
  String? validateName(String? name) => name != null && name.isEmpty ? 'Name can\'t be empty.' : null;

  String? validateEmail(String? email) {
    if (email != null) {
      if (email.isEmpty) {
        return 'Email can\'t be empty.';
      } else if (!RegExp(regexEmail).hasMatch(email)) {
        return 'Enter a correct email address.';
      }
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password != null) {
      if (password.isEmpty) {
        return 'Password can\'t be empty.';
      } else if (password.length < 6) {
        return 'Password must be at least 6 characters long.';
      }
    }
    return null;
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = '/login';
  static const String homeRoute = '/home';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin, ValidateCredential {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  late AnimationController _animCtrl;

  bool _staySignedIn = true;
  bool _createNew = false;
  bool _busy = false;
  String? _uniqueUserID;
  User? _user;

  void _getLoginInfo() {
    final Box<Map<dynamic, dynamic>> _loginBox = Hive.box(keyLoginBox);
    if (_loginBox.containsKey(keyLoginBox)) {
      final Map<String, dynamic> _login = Map<String, dynamic>.from(_loginBox.get(keyLoginBox)!);
      setState(() {
        _uniqueUserID = _login[keyIsFirstLaunch] as String?;
        _staySignedIn = _login[keyKeepLoggedIn] as bool? ?? true;
        if (_staySignedIn) {
          _usernameCtrl.text = _login[keyUsername] as String? ?? '';
          _passwordCtrl.text = _login[keyPassword] as String? ?? '';
        }
      });
    }
  }

  Future<void> _setLoginInfo() async {
    final Box<Map<dynamic, dynamic>> _loginBox = Hive.box(keyLoginBox);
    final Map<String, dynamic> _login = <String, dynamic>{keyKeepLoggedIn: _staySignedIn || _createNew};
    if (_uniqueUserID != null && _uniqueUserID == _usernameCtrl.text) {
      _login[keyIsFirstLaunch] = _usernameCtrl.text;
    } else {
      _login[keyIsFirstLaunch] = _usernameCtrl.text;
      await FirebaseFirestore.instance
          .collection(keyAllUsers)
          .doc(_usernameCtrl.text)
          .set(<String, dynamic>{'LastActive': DateTime.now()});
    }
    if (_staySignedIn || _createNew) {
      _login[keyUsername] = _usernameCtrl.text;
      _login[keyPassword] = _passwordCtrl.text;
    }
    await _loginBox.put(keyLoginBox, _login);
  }

  Future<void> _authenticate(AnimationStatus status) async {
    if (status == AnimationStatus.forward) {
      if (_formKey.currentState!.validate() && !_busy) {
        _busy = true;
        _user = await authenticate(
          context,
          create: _createNew,
          name: _nameCtrl.text,
          username: _usernameCtrl.text,
          password: _passwordCtrl.text,
        );
        if (_user != null) await _setLoginInfo();
      }
    } else if (status == AnimationStatus.completed) {
      _busy = false;
      if (_user != null) {
        await Navigator.pushReplacementNamed(context, Login.homeRoute, arguments: _usernameCtrl.text);
      } else {
        await _animCtrl.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLoginInfo();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener(_authenticate);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tendon Loader - ${_createNew ? 'Register' : 'Login'}')),
      body: kIsWeb ? Center(child: SizedBox(width: sizeleftPanel, child: _buildLoginBody())) : _buildLoginBody(),
    );
  }

  Widget _buildLoginBody() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const AppLogo(),
              if (_createNew)
                CustomTextField(
                  label: 'Your name',
                  hint: 'Enter your name',
                  controller: _nameCtrl,
                  validator: validateName,
                  keyboardType: TextInputType.name,
                ),
              CustomTextField(
                label: 'Username',
                hint: 'Enter your username',
                controller: _usernameCtrl,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                isObscure: true,
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordCtrl,
                keyboardType: TextInputType.visiblePassword,
                validator: validatePassword,
              ),
              const SizedBox(height: 10),
              if (!_createNew)
                ListTile(
                  leading: Icon(
                    _staySignedIn ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  onTap: () => setState(() => _staySignedIn = !_staySignedIn),
                  title: const Text('Keep me logged in.', style: TextStyle(fontSize: 14)),
                ),
              GestureDetector(
                onTap: () {
                  setState(() => _createNew = !_createNew);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Disabled for testing version...!')),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    _createNew ? 'Already have an account? Sign in.' : 'Don\'t have an account? Sign up',
                    style: const TextStyle(letterSpacing: 0.5, color: Colors.blue),
                  ),
                ),
              ),
              // const SizedBox(height: 30),
              // GestureDetector(
              //   onTap: () async {
              //     User user = await Authentication.signInWithGoogle(context);
              //     if (user != null) print(user.email);
              //   },
              //   child: const Text(
              //     'Sign in with Google',
              //     style: const TextStyle(letterSpacing: 1.5, color: Colors.red, fontSize: 16),
              //   ),
              // ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl),
                  child: CustomFab(icon: Icons.send, onTap: _animCtrl.forward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
