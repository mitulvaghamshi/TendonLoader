import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/login/signup.dart';
import 'package:tendon_loader/utils/authentication.dart';
import 'package:tendon_loader/utils/validator.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  static const String routeName = '/';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();
  AnimationController _rotateCtrl;
  bool _busy = false;
  User _user;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
      ..addStatusListener((status) async {
        if (_rotateCtrl.status == AnimationStatus.completed) {
          if (true/*_user != null*/) {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          } else {
            _rotateCtrl.reverse();
            _busy = false;
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
      body: FutureBuilder(
        future: Authentication.init(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) return _buildSignInBody();
          return const Center(child: const CustomImage(zeroPad: true));
        },
      ),
    );
  }

  SingleChildScrollView _buildSignInBody() {
    return SingleChildScrollView(
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(16),
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
                  child: const ClipOval(child: const CustomImage(name: 'male_avatar.webp', zeroPad: true)),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _signInFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Username',
                      controller: _emailCtrl,
                      hint: 'Enter your username',
                      validator: Validator.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      isObscure: true,
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordCtrl,
                      keyboardType: TextInputType.text,
                      validator: Validator.validatePassword,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(value: true, onChanged: (newValue) {}),
                  const Text('Keep me logged in.'),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, SignUp.routeName),
                child: const Text(
                  'Don\'t have an account? Sign up',
                  style: const TextStyle(letterSpacing: 0.5, color: Colors.blue, height: 5),
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
                    turns: Tween(begin: 0.0, end: 1.0).animate(_rotateCtrl),
                    child: FloatingActionButton(
                      heroTag: 'sign-in-tag',
                      child: Icon(Icons.send),
                      onPressed: () async {
                        // if (_signInFormKey.currentState.validate() && !_busy) {
                          _busy = true;
                          _rotateCtrl.forward();
                          // _user = await Authentication.signIn(
                          //   context: context,
                          //   email: _emailCtrl.text,
                          //   password: _passwordCtrl.text,
                          // );
                        // }
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
