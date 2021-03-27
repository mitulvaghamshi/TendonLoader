import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/home.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/validator.dart' show ValidateCredentialMixin;
import 'package:tendon_loader/webportal/homepage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key/*?*/ key}) : super(key: key);

  static const String routeName = '/sigIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin, ValidateCredentialMixin, Keys {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  AnimationController _rotateCtrl;
  bool _busy = false;
  User/*?*/ _user;

  SharedPreferences _preferences;
  bool/*?*/ _staySignedIn = true;

  Future<void> _getLoginInfo() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _staySignedIn = _preferences.getBool(Keys.keyStaySignIn) ?? true;
      if (_staySignedIn/*!*/) {
        _usernameCtrl.text = _preferences.getString(Keys.keyUsername) ?? '';
        _passwordCtrl.text = _preferences.getString(Keys.keyPassword) ?? '';
      }
    });
  }

  Future<void> _setLoginInfo() async {
    await _preferences.setBool(Keys.keyStaySignIn, _staySignedIn/*!*/);
    if (_staySignedIn/*!*/) {
      await _preferences.setString(Keys.keyUsername, _usernameCtrl.text);
      await _preferences.setString(Keys.keyPassword, _passwordCtrl.text);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLoginInfo();
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..addStatusListener((AnimationStatus status) async {
        if (_rotateCtrl.status == AnimationStatus.completed) {
          if (/*_user != null*/ true) {
            await _setLoginInfo();
            await Navigator.pushReplacementNamed(context, kIsWeb ? HomePage.routeName : Home.routeName);
          } else {
            _busy = false;
            await _rotateCtrl.reverse();
          }
        }
      });
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader - Login'), centerTitle: true),
      body: kIsWeb ? Center(child: SizedBox(width: 350, child: _buildSignInBody())) : _buildSignInBody(),
    );
  }

  Widget _buildSignInBody() {
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: Colors.blue)),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Theme.of(context).primaryColor,
                child: ClipOval(child: CustomImage(color: Theme.of(context).accentColor)),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _signInFormKey,
              child: Column(
                children: <CustomTextField>[
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
                    validator: validatePassword,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(value: _staySignedIn, onChanged: (bool/*?*/ value) => setState(() => _staySignedIn = value)),
                const Text('Stay signed in.', style: TextStyle(letterSpacing: 3)),
              ],
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please contact your clinician!!!')));
                // Navigator.pushReplacementNamed(context, SignUp.routeName);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Don\'t have an account? Sign up', style: TextStyle(letterSpacing: 0.5, color: Colors.blue)),
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
                  turns: Tween<double>(begin: 0.0, end: 1.0).animate(_rotateCtrl),
                  child: FloatingActionButton(
                    heroTag: 'sign-in-tag',
                    child: const Icon(Icons.send),
                    onPressed: () async {
                      if (_signInFormKey.currentState/*!*/.validate() && !_busy) {
                        // _user = await Authentication.signIn(context: context, email: _usernameCtrl.text, password: _passwordCtrl.text);
                        await _rotateCtrl.forward();
                        _busy = true;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
