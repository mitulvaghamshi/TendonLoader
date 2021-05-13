import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/login/login.dart';

class AppAuth {
  static void _showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  static Future<void> init() async {
    return Future<void>.delayed(const Duration(seconds: 2), () async => Firebase.initializeApp());
  }

  static Future<User> authenticate(BuildContext context, {bool create, String name, String username, String password}) {
    if (kIsWeb) FirebaseAuth.instance.setPersistence(Persistence.NONE);
    return create ? _signUp(context, name, username, password) : _signIn(context, username, password);
  }

  static User user() => FirebaseAuth.instance.currentUser;

  static Future<User> _signUp(BuildContext context, String name, String username, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(email: username, password: password);
      user = userCredential.user;
      await user.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showSnackBar(context, 'The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showSnackBar(context, 'The account already exists for that email.');
      }
    }
    return user;
  }

  static Future<User> _signIn(BuildContext context, String username, String password) async {
    User user;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(email: username, password: password);
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

  static Future<User> refreshUser(User user) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    return auth.currentUser;
  }

  static Future<void> signOut() async {
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // if (!kIsWeb) await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // 
    }
  }

// static Future<bool> biometrics() async {
//   final LocalAuthentication localAuthentication = LocalAuthentication();
//   final bool isBiometricSupported = await localAuthentication.isDeviceSupported();
//   final bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
//   bool isAuthenticated = false;
//   if (isBiometricSupported && canCheckBiometrics) {
//     // final List<BiometricType> biometricTypes = await localAuthentication.getAvailableBiometrics();
//     isAuthenticated = await localAuthentication.authenticate(
//       localizedReason: 'Please complete the biometrics to proceed.',
//       biometricOnly: true,
//       // androidAuthStrings: AndroidAuthMessages(
//       //   biometricHint: 'Verify identity using biometrics',
//       //   biometricRequiredTitle: 'Accessing secret vault',
//       //   deviceCredentialsRequiredTitle: 'Identity verification using biometrics is required to proceed to the secret vault.',
//       // ),
//     );
//   }
//   return isAuthenticated;
// }

// static Future<User> signInWithGoogle(BuildContext context) async {
//   User user;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   if (kIsWeb) {
//     final GoogleAuthProvider authProvider = GoogleAuthProvider();
//     try {
//       final UserCredential userCredential = await auth.signInWithPopup(authProvider);
//       user = userCredential.user;
//     } catch (e) {
//       // ignore: avoid_print
//       print(e);
//     }
//   } else {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//     if (googleSignInAccount != null) {
//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       try {
//         final UserCredential userCredential = await auth.signInWithCredential(credential);
//         user = userCredential.user;
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'account-exists-with-different-credential') {
//           customSnackBar(context, 'The account already exists with a different credential');
//         } else if (e.code == 'invalid-credential') {
//           customSnackBar(context, 'Error occurred while accessing credentials. Try again.');
//         }
//       } catch (e) {
//         customSnackBar(context, 'Error occurred using Google Sign In. Try again.');
//       }
//     }
//   }
//   return user;
// }
}
