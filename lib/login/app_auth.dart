import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void _snackBar(BuildContext context, String content) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));

Future<void> initApp() async {
  await Firebase.initializeApp();
  if (true) {
    await FirebaseAuth.instance.useEmulator('http://localhost:9099');
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
}

Future<User?> authenticate(BuildContext context, bool isNew, String email, String password) async {
  if (kIsWeb) await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  late final UserCredential? _credential;
  try {
    _credential = isNew
        ? await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        : await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      _snackBar(context, 'No user found for that email. Make sure you enter right credentials.');
    } else if (e.code == 'wrong-password') {
      _snackBar(context, 'Invalid password.');
    } else if (e.code == 'weak-password') {
      _snackBar(context, 'The password is too weak.');
    } else if (e.code == 'email-already-in-use') {
      _snackBar(context, 'The account already exists for that email.');
    }
    return null;
  }
  return _credential.user;
}

Future<void> signOut() async {
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    // if (!kIsWeb) await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  } catch (_) {}
}

/* 
Future<User> signInWithGoogle(BuildContext context) async {
  User user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  if (kIsWeb) {
    final GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      final UserCredential userCredential = await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (_) {}
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          _showSnackBar(context, 'The account already exists with a different credential');
        } else if (e.code == 'invalid-credential') {
          _showSnackBar(context, 'Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        _showSnackBar(context, 'Error occurred using Google Sign In. Try again.');
      }
    }
  }
  return user;
}
*/
