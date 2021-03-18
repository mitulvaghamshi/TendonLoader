import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/signin/sign_in_form.dart';
import 'package:tendon_loader/utils/authentication.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Authentication.initializeFirebase(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              // return GoogleSignInButton();
              return SignInForm(emailFocusNode: _emailFocusNode, passwordFocusNode: _passwordFocusNode);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
