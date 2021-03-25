import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/login/signin.dart';
import 'package:tendon_loader/utils/authentication.dart';
import 'package:tendon_loader/utils/validator.dart' show ValidateCredentialMixin;

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  static const String routeName = '/signUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin, ValidateCredentialMixin {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  AnimationController _rotateCtrl;
  bool _busy = false;
  User _user;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..addStatusListener((AnimationStatus status) async {
        if (_rotateCtrl.status == AnimationStatus.completed) {
          if (_user != null) {
            await Navigator.pushReplacementNamed(context, HomePage.routeName);
          } else {
            await _rotateCtrl.reverse();
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
      appBar: AppBar(title: const Text('Tendon Loader - Register'), centerTitle: true),
      body: FutureBuilder<FirebaseApp>(
        future: Authentication.init(),
        builder: (_, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildSignUpBody();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  SingleChildScrollView _buildSignUpBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: Colors.green)),
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.greenAccent,
                  child: ClipOval(child: CustomImage(name: 'male_avatar.webp', zeroPad: true)),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _signUpFormKey,
                child: Column(
                  children: <CustomTextField>[
                    CustomTextField(
                      label: 'Name',
                      hint: 'Enter your name',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: validateName,
                    ),
                    CustomTextField(
                      label: 'Username',
                      hint: 'Enter your username',
                      controller: _emailController,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      isObscure: true,
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      validator: validatePassword,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, SignIn.routeName),
                child: const Text(
                  'Already have an account? Sign in.',
                  style: TextStyle(letterSpacing: 0.5, color: Colors.blue, height: 5),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 1.0).animate(_rotateCtrl),
                    child: FloatingActionButton(
                      heroTag: 'sign-up-tag',
                      onPressed: () async {
                        if (_signUpFormKey.currentState.validate() && !_busy) {
                          _busy = true;
                          await _rotateCtrl.forward();
                          _user = await Authentication.signIn(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      child: const Icon(Icons.send),
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
