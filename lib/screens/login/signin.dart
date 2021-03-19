import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_formfield.dart';
import 'package:tendon_loader/utils/validator.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  static const String routeName = '/signIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();
  bool _isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0),
            child: Column(
              children: [
                CustomFormField(
                  label: 'Email',
                  controller: _emailCtrl,
                  hint: 'Enter your email',
                  validator: Validator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                CustomFormField(
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
          _isBusy
              ? const Padding(padding: const EdgeInsets.all(20), child: const CircularProgressIndicator())
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    onPressed: () async {
                      setState(() => _isBusy = true);
                      if (_signInFormKey.currentState.validate()) {
                        // User user = await Authentication.signInUsingEmailPassword(
                        //   context: context,
                        //   email: _emailCtrl.text,
                        //   password: _passwordCtrl.text,
                        // );
                        // if (user != null) {} //  navigate.push with user
                      }
                      setState(() => _isBusy = false);
                    },
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        'LOGIN',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {},
            child: const Text('Don\'t have an account? Sign up', style: const TextStyle(letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }
}
