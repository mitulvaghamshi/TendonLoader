import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/screens/login/signin.dart';
import 'package:tendon_loader/utils/authentication.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login', textAlign: TextAlign.center)),
      body: SafeArea(
        child: Card(
          elevation: 16,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: FutureBuilder(
            future: Authentication.initializeFirebase(context),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const SignIn();
              } else if (snapshot.hasError) {
                return const CustomImage();
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
