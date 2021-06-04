import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, Persistence, User, UserCredential;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

void _showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<void> initApp() async => Firebase.initializeApp();

Future<User?> authenticate(BuildContext context,
    {required bool create, String? name, String? username, String? password}) {
  if (kIsWeb) FirebaseAuth.instance.setPersistence(Persistence.NONE);
  return create ? _signUp(context, name, username!, password!) : _signIn(context, username!, password!);
}

User? get _user => FirebaseAuth.instance.currentUser;

Future<User?> _signUp(BuildContext context, String? name, String username, String password) async {
  User? user;
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: username, password: password);
    user = userCredential.user;
    await user!.updateProfile(displayName: name);
    await user.reload();
    user = _user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      _showSnackBar(context, 'The password is too weak.');
    } else if (e.code == 'email-already-in-use') {
      _showSnackBar(context, 'The account already exists for that email.');
    }
  }
  return user;
}

Future<User?> _signIn(BuildContext context, String username, String password) async {
  User? user;
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
    user = userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      _showSnackBar(context, 'No user found for that email. Make sure you enter right credentials.');
    } else if (e.code == 'wrong-password') {
      _showSnackBar(context, 'Invalid password.');
    }
  }
  return user;
}

Future<User?> refreshUser(User user) async {
  await user.reload();
  return _user;
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
