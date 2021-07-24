import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

final Map<String, String> _errors = <String, String>{
  'email-already-in-use': 'The account already exists for that email.',
  'invalid-email': 'Invalid email.',
  'weak-password': 'The password is too weak.',
  'wrong-password': 'Invalid password.',
  'user-not-found': 'No user found for that email. Make sure you enter right credentials.',
  'user-disabled': 'This account is disabled.',
  'operation-not-allowed': 'This account is disabled.',
};

Future<void> initFirebase() async {
  await Firebase.initializeApp();
  // await _useEmulator();
}

User? get currentUser => FirebaseAuth.instance.currentUser;

Future<void> firebaseLogout() async {
  try {
    await FirebaseAuth.instance.signOut();
  } finally {}
}

Future<bool> authenticate(BuildContext context, bool isNew, String email, String password) async {
  try {
    final UserCredential _credential = isNew
        ? await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        : await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return _credential.user != null;
  } on FirebaseAuthException catch (e) {
    context.showSnackBar(Text(_errors[e.code] ?? 'Unable to reach the internet.',
        style: const TextStyle(color: colorRed400, fontWeight: FontWeight.bold)));
    return false;
  }
}

Future<void> _useEmulator() async {
  const String host = '10.0.0.110';
  await FirebaseAuth.instance.useAuthEmulator(host, 10001);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 10002);
}
