import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/colors.dart';

final Map<String, String> _errors = <String, String>{
  'email-already-in-use': 'The account already exists for that email.',
  'invalid-email': 'Invalid email.',
  'weak-password': 'The password is too weak.',
  'wrong-password': 'Invalid password.',
  'user-not-found': 'No user found for that email. Make sure you enter right credentials.',
  'user-disabled': 'This account is disabled.',
  'operation-not-allowed': 'This account is disabled.',
};

Future<void> initApp() async {
  await Firebase.initializeApp();
  await _useEmulator();
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (_) {}
}

Future<bool> authenticate(BuildContext context, bool isNew, String email, String password) async {
  try {
    final UserCredential _credential = isNew
        ? await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        : await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return _credential.user != null;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_errors[e.code] ?? 'Unable to Login/Register. Try again later.',
            style: const TextStyle(color: colorRed400, fontWeight: FontWeight.bold))));
    return false;
  }
}

Future<void> _useEmulator() async {
  final String host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
  await FirebaseAuth.instance.useEmulator('http://$host:9099');
  FirebaseFirestore.instance.settings = Settings(
    host: '$host:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}
