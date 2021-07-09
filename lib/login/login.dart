import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/others.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/homepage.dart';
import 'package:tendon_loader/homescreen.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = '/login';
  static const String homeRoute = kIsWeb ? HomePage.route : HomeScreen.route;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AnimationController _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
    ..addStatusListener(_authenticate);

  bool _isNew = false;
  bool _result = false;
  bool _keepSigned = true;

  Future<void> _authenticate(AnimationStatus status) async {
    if (status == AnimationStatus.forward) {
      _result = await authenticate(context, _isNew, _emailCtrl.text, _passwordCtrl.text);
      if (_result) {
        context.model.userState!
          ..keepSigned = _keepSigned
          ..userName = _emailCtrl.text
          ..passWord = _passwordCtrl.text;
        await context.model.initAppUser();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _keepSigned = context.model.userState!.keepSigned!;
    if (_keepSigned) {
      _emailCtrl.text = context.model.userState!.userName!;
      _passwordCtrl.text = context.model.userState!.passWord!;
    }
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tendon Loader - ${_isNew ? 'Register' : 'Login'}'),
      ),
      body: kIsWeb ? Center(child: SizedBox(width: sizeleftPanel, child: _buildLoginBody())) : _buildLoginBody(),
    );
  }

  Widget _buildLoginBody() {
    return SingleChildScrollView(
      child: AppFrame(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: AppLogo()),
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
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () => setState(() => _isNew = !_isNew),
              icon: Icon(_isNew ? Icons.check_rounded : Icons.add, color: colorGoogleGreen),
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
                  icon: Icon(_isNew ? Icons.add : Icons.send_rounded),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) _animCtrl.forward();
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
