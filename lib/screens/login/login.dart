import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/homescreen.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  late final AnimationController _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
    ..addStatusListener(_authenticate);

  bool _isNew = false;
  bool _result = false;
  bool _keepSigned = true;
  bool _isObscure = true;

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
        await context.push(Login.homeRoute, replace: true);
      } else {
        await _animCtrl.reverse();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.model.userState != null && (_keepSigned = context.model.userState!.keepSigned!)) {
      _emailCtrl.text = context.model.userState!.userName!;
      _passwordCtrl.text = context.model.userState!.passWord!;
    } else {
      _keepSigned = true;
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
      body: kIsWeb ? Center(child: SizedBox(width: 370, child: _buildForm())) : _buildForm(),
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
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              label: 'Password',
              isObscure: _isObscure,
              controller: _passwordCtrl,
              validator: validatePassword,
              keyboardType: TextInputType.visiblePassword,
              suffix: IconButton(
                onPressed: () => setState(() => _isObscure = !_isObscure),
                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            CheckboxListTile(
              value: _keepSigned,
              activeColor: colorGoogleGreen,
              contentPadding: EdgeInsets.zero,
              title: const Text('Keep me logged in.'),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (_) => setState(() => _keepSigned = !_keepSigned),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
              child: RotationTransition(
                turns: Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl),
                child: CustomButton(
                  rounded: true,
                  
                  left: Icon(_isNew ? Icons.add : Icons.send),
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
