// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:tendon_loader/modal/settings_state.dart';
// import 'package:tendon_loader/modal/user_state.dart';
// import 'package:tendon_loader/utils/common.dart';
// import 'package:tendon_loader/utils/themes.dart';

// Future<void> authenticate() async {
//   if (!_isBusy && _formKey.currentState!.validate()) {
//     setState(() => _isBusy = true);
//     try {
//       final UserCredential _credential = await (_isRegister
//           ? FirebaseAuth.instance.createUserWithEmailAndPassword
//           : FirebaseAuth.instance.signInWithEmailAndPassword)(
//         email: _emailCtrl.text,
//         password: _passwordCtrl.text,
//       );
//       if (_credential.user != null && await initUser()) {
//         await Future<void>.delayed(const Duration(seconds: 2));
//         await context.replace(Login.homeRoute);
//       } else if (kIsWeb) {
//         setState(() => _isBusy = false);
//         if (_isRegister && !_isAdmin) {
//           context.showSnackBar(const Text('User created successfully!!!'));
//         } else {
//           context.showSnackBar(const Text(
//             'Access denied! are you a clinician?',
//             style: TextStyle(color: colorRed400),
//           ));
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() => _isBusy = false);
//       context.showSnackBar(Text(
//         firebaseErrors[e.code] ?? 'Unable to reach the internet.',
//         style: const TextStyle(color: colorRed400),
//       ));
//     }
//   }
// }

// Future<bool> initUser() async {
//   try {
//     _userState!
//       ..keepSigned = _keepSigned
//       ..userName = _emailCtrl.text
//       ..passWord = _passwordCtrl.text;
//     if (_userState!.isInBox) {
//       await _userState!.save();
//     } else {
//       await boxUserState.put(keyUserStateBoxItem, _userState!);
//     }
//     late final SettingsState _settingsState;
//     if (boxSettingsState.containsKey(_emailCtrl.text.hashCode)) {
//       _settingsState = boxSettingsState.get(_emailCtrl.text.hashCode)!;
//     } else {
//       await boxSettingsState.put(
//         _emailCtrl.text.hashCode,
//         _settingsState = SettingsState(),
//       );
//       await dbRoot
//           .doc(_emailCtrl.text)
//           .get()
//           .then((DocumentSnapshot<Patient> patient) async {
//         if (!patient.exists) {
//           await dbRoot.doc(_emailCtrl.text).set(Patient(
//                 prescription: Prescription.empty()..isAdmin = _isAdmin,
//               ));
//         }
//       });
//     }
//     final Patient _patient = await Patient.of(_emailCtrl.text).fetch();
//     _settingsState.toggle(
//       _settingsState.customPrescriptions!,
//       _patient,
//     );
//     context
//       ..patient = _patient
//       ..userState = _userState
//       ..settingsState = _settingsState;
//     return !kIsWeb || _patient.prescription!.isAdmin!;
//   } on Exception {
//     return false;
//   }
// }
