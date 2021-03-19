import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_formfield.dart';
import 'package:tendon_loader/utils/validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  static const String routeName = '/signUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();
  bool _isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CustomFormField(
                  label: 'Name',
                  hint: 'Enter your name',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: Validator.validateName,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  validator: Validator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  isObscure: true,
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  validator: Validator.validatePassword,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _isBusy
              ? const Padding(padding: const EdgeInsets.all(16.0), child: const CircularProgressIndicator())
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
                      if (_signUpFormKey.currentState.validate()) {
                        // User user = await Authentication.registerUsingEmailPassword(
                        //   context: context,
                        //   name: _nameController.text,
                        //   email: _emailController.text,
                        //   password: _passwordController.text,
                        // );
                        // if (user != null) {} // push
                      }
                      setState(() => _isBusy = false);
                    },
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        'REGISTER',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () {},
            child: const Text('Already have an account? Sign in', style: const TextStyle(letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }
}
