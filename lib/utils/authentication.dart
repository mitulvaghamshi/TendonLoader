import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

class Authentication {
  static void customSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(content, style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5)),
    ));
  }

  static Future<FirebaseApp> init() async {
    return null;
    // return Future.delayed(const Duration(seconds: 1), () async => await Firebase.initializeApp());
  }

  static Future<User> signIn({String email, String password, BuildContext context}) async {
    User user;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnackBar(context, 'No user found for that email. Make sure you enter right credentials.');
      } else if (e.code == 'wrong-password') {
        customSnackBar(context, 'Invalid password.');
      }
    }
    return user;
  }

  static Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      customSnackBar(context, 'Error signing out. Try again.');
    }
  }

  static Future<bool> biometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    bool isAuthenticated = false;
    if (isBiometricSupported && canCheckBiometrics) {
      List<BiometricType> biometricTypes = await localAuthentication.getAvailableBiometrics();
      print(biometricTypes);
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        biometricOnly: true,
        // androidAuthStrings: AndroidAuthMessages(
        //   biometricHint: 'Verify identity using biometrics',
        //   biometricRequiredTitle: 'Accessing secret vault',
        //   deviceCredentialsRequiredTitle: 'Identity verification using biometrics is required to proceed to the secret vault.',
        // ),
      );
    }
    return isAuthenticated;
  }

// {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();
//     User user = FirebaseAuth.instance.currentUser;
//     return firebaseApp;
// }

// static Future<User> refreshUser(User user) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   await user.reload();
//   return auth.currentUser;
// }

  static Future<User> signUp({
    @required String name,
    @required String email,
    @required String password,
    @required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await user.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        customSnackBar(context, 'The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        customSnackBar(context, 'The account already exists for that email.');
      }
    }
    return user;
  }

// static Future<User> signInWithGoogle(BuildContext context) async {
//   User user;
//   FirebaseAuth auth = FirebaseAuth.instance;
//
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//
//   if (googleSignInAccount != null) {
//     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );
//     try {
//       final UserCredential userCredential = await auth.signInWithCredential(credential);
//       user = userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'account-exists-with-different-credential') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           customSnackBar('The account already exists with a different credential'),
//         );
//       } else if (e.code == 'invalid-credential') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           customSnackBar('Error occurred while accessing credentials. Try again.'),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         customSnackBar('Error occurred using Google Sign In. Try again.'),
//       );
//     }
//   }
//   return user;
// }
}
