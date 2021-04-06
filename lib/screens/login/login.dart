import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/portal/homepage.dart';
import 'package:tendon_loader/screens/home.dart';
import 'package:tendon_loader/utils/app_auth.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/validator.dart' show ValidateCredentialMixin;

class Login extends StatelessWidget {
  const Login({Key/*?*/ key}) : super(key: key);

  static const String route = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tendon Loader - ${_createNew ? 'Register' : 'Login'}')),
      body: kIsWeb ? Center(child: SizedBox(width: Sizes.sizeMobile, child: _buildLoginBody())) : _buildLoginBody(),
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
                keyboardType: TextInputType.name,
                validator: validateName,
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
                  const Text('Stay signed in.', style: TextStyle(letterSpacing: 3)),
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
                  child: FloatingActionButton(heroTag: 'login-tag', child: const Icon(Icons.send), onPressed: _animCtrl.forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
