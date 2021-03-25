import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/login/signup.dart';
import 'package:tendon_loader/utils/authentication.dart';
import 'package:tendon_loader/utils/validator.dart' show ValidateCredentialMixin;

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  static const String routeName = '/';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin, ValidateCredentialMixin {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  AnimationController _rotateCtrl;
  bool _busy = false;
  User _user;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..addStatusListener((AnimationStatus status) async {
        if (_rotateCtrl.status == AnimationStatus.completed) {
          if (_user != null)
            await Navigator.pushReplacementNamed(context, HomePage.routeName);
          else {
            _busy = false;
            await _rotateCtrl.reverse();
          }
        }
      });
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader - Login'), centerTitle: true),
      body: FutureBuilder<FirebaseApp>(
        future: Authentication.init(),
        builder: (_, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) return _buildSignInBody();
          return const Center(child: CustomImage(zeroPad: true));
        },
      ),
    );
  }

  SingleChildScrollView _buildSignInBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Card(
        elevation: 16,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 50),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: Colors.blue)),
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.blueAccent,
                  child: ClipOval(child: CustomImage(name: 'male_avatar.webp', zeroPad: true)),
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
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
              Row(children: <Widget>[Checkbox(value: true, onChanged: (bool value) {}), const Text('Keep me logged in.')]),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, SignUp.routeName),
                child: const Text('Don\'t have an account? Sign up', style: TextStyle(letterSpacing: 0.5, color: Colors.blue, height: 5)),
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
                        if (_signInFormKey.currentState.validate() && !_busy) {
                          _busy = true;
                          await _rotateCtrl.forward();
                          _user = await Authentication.signIn(context: context, email: _emailCtrl.text, password: _passwordCtrl.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
