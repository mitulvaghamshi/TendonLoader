import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app/home.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/custom/custom_textfield.dart';
import 'package:tendon_loader/shared/validator.dart';
import 'package:tendon_loader/web/homepage.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  static const String route = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin, ValidateCredentialMixin, Keys {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  AnimationController _animCtrl;
  Box<Object> _loginBox;
  bool _staySignedIn = true;
  bool _createNew = false;
  bool _busy = false;
  User _user;

  Future<void> _getLoginInfo() async {
    _loginBox = await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX);
    setState(() {
      _staySignedIn = _loginBox.get(Keys.KEY_STAY_SIGN_IN, defaultValue: true) as bool;
      if (_staySignedIn) {
        _usernameCtrl.text = _loginBox.get(Keys.KEY_USERNAME, defaultValue: '') as String;
        _passwordCtrl.text = _loginBox.get(Keys.KEY_PASSWORD, defaultValue: '') as String;
      }
    });
  }

  Future<void> _setLoginInfo() async {
    await _loginBox.put(Keys.KEY_STAY_SIGN_IN, _staySignedIn || _createNew);
    if (_staySignedIn || _createNew) {
      await _loginBox.put(Keys.KEY_USERNAME, _usernameCtrl.text);
      await _loginBox.put(Keys.KEY_PASSWORD, _passwordCtrl.text);
    }
  }

  Future<void> _authenticate(AnimationStatus status) async {
    if (status == AnimationStatus.forward) {
      if (_loginFormKey.currentState.validate() && !_busy) {
        _busy = true;
        _user = await AppAuth.authenticate(
          context,
          create: _createNew,
          name: _nameCtrl.text ?? '',
          username: _usernameCtrl.text,
          password: _passwordCtrl.text,
        );
      }
    } else if (status == AnimationStatus.completed) {
      _busy = false;
      if (_user != null) {
        await _setLoginInfo();
        await Navigator.pushReplacementNamed(context, kIsWeb ? HomePage.route : Home.route);
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
    _nameCtrl.dispose();
    _animCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tendon Loader - ${_createNew ? 'Register' : 'Login'}')),
      body: kIsWeb ? Center(child: SizedBox(width: Sizes.SIZE_MOBILE, child: _buildLoginBody())) : _buildLoginBody(),
    );
  }

  Widget _buildLoginBody() {
    return AppFrame(
      isScrollable: true,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CustomImage(isLogo: true),
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
              action: TextInputAction.send,
              keyboardType: TextInputType.text,
              validator: validatePassword,
            ),
            if (!_createNew)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(value: _staySignedIn, onChanged: (bool value) => setState(() => _staySignedIn = value)),
                  const Text('Keep me logged in.', style: TextStyle(letterSpacing: 3)),
                ],
              ),
            GestureDetector(
              onTap: () => setState(() => _createNew = !_createNew),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl),
                  child: FloatingActionButton(onPressed: _animCtrl.forward, child: const Icon(Icons.send)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}