// final Map<String, Patient> users = HashMap<String, Patient>();
// Completer<void> _complater = Completer<void>();
// void setRefetch() => _complater = Completer<void>();
// Future<void> fetch() async {
//   if (_complater.isCompleted) return;
//   final QuerySnapshot<Patient> result = await dbRoot.get();
//   if (result.size > 0) users.clear();
//   for (int i = 0; i < result.size; i++) {
//     final Patient user = result.docs[i].data();
//     users[user.id] = await user.fetch(withExports: true);
//   }
//   _complater.complete();
//   return _complater.future;
// }
// Iterable<String> filterUsers(String filter) {
//   if (filter.isEmpty) return users.keys;
//   final List<String> result = <String>[];
//   for (final MapEntry<String, Patient> user in users.entries) {
//     if (user.value.id.toLowerCase().contains(filter.toLowerCase())) {
//       result.add(user.key);
//     }
//   }
//   return result;
// }
// Iterable<Export>? filterExports(String? filter, String userId) {
//   final Iterable<Export>? exportList = users[userId]?.exports;
//   if (filter == null) return exportList;
//   final Iterable<Export>? filtered = exportList?.where((Export export) {
//     return export.fileName.toLowerCase().contains(filter.toLowerCase());
//   });
//   return filtered;
// }
// Export? getExport(int index, String? userId) =>
//     users[userId]?.exports?[index];
// Future<void> removeExport(Export export, String id) async {
//   final Patient user = users[id]!;
//   user.exports!.remove(export);
//   // setState(() => users[id] = user);
//   await export.reference!.delete();
// }
// Future<void> removeAllExports(String id) async {
//   final Patient user = users[id]!;
//   user.exports!.clear();
//   // setState(() => users[id] = user);
//   await user.deleteAll();
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tendon_loader/models/patient.dart';
// import 'package:tendon_loader/models/prescription.dart';
// import 'package:tendon_loader/models/router.dart';
// import 'package:tendon_loader/models/settings_state.dart';
// import 'package:tendon_loader/models/user_state.dart';
// import 'package:tendon_loader/utils/common.dart';
// import 'package:tendon_loader/utils/constants.dart';
// import 'package:tendon_loader/widgets/app_logo.dart';
// import 'package:tendon_loader/widgets/button_tile.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key, required this.create});

//   final bool create;

//   @override
//   LoginScreenState createState() => LoginScreenState();
// }

// class LoginScreenState extends State<LoginScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailCtrl = TextEditingController();
//   final TextEditingController _passwordCtrl = TextEditingController();

//   UserState? _userState;

//   bool _isBusy = false;
//   bool _isObscure = true;
//   bool _keepSigned = true;
//   bool _isAdmin = false;
//   bool _isCreate = false;

//   void _setState({required bool isBusy, String message = ''}) {
//     setState(() => _isBusy = isBusy);
//     if (message.isNotEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(message)));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (!widget.create) {
//       _userState = boxUserState.get(
//         keyUserStateBox,
//         defaultValue: UserState(),
//       );
//       if (_userState != null && (_keepSigned = _userState!.keepSigned!)) {
//         _emailCtrl.text = _userState!.userName!;
//         _passwordCtrl.text = _userState!.passWord!;
//       } else {
//         _keepSigned = true;
//       }
//     } else {
//       _userState = UserState();
//     }
//   }

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passwordCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: widget.create
//           ? AppBar(
//               title: const Text('Create new user'),
//               leading: ButtonTile(
//                 child: const Icon(Icons.clear, color: Color(0xffff534d)),
//                 onPressed: () => context.pop(),
//               ),
//             )
//           : null,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               runAlignment: WrapAlignment.center,
//               crossAxisAlignment: WrapCrossAlignment.center,
//               children: <Widget>[
//                 const SizedBox(height: 350, child: AppLogo()),
//                 SizedBox(width: 400, child: _buildForm()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Column _buildForm() {
//     return Column(
//       children: <Widget>[
//         TextFormField(
//           controller: _emailCtrl,
//           keyboardType: TextInputType.emailAddress,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           style: titleStyle,
//           decoration: InputDecoration(
//             labelText: 'Username',
//             suffix: IconButton(
//               onPressed: _emailCtrl.clear,
//               icon: const Icon(Icons.clear),
//             ),
//           ),
//           validator: (String? value) {
//             if (value == null) return null;
//             if (value.isEmpty) {
//               return 'Email can\'t be empty.';
//             } else if (!RegExp(emailRegEx).hasMatch(value)) {
//               return 'Enter a correct email address.';
//             }
//             return null;
//           },
//         ),
//         TextFormField(
//           obscureText: _isObscure,
//           controller: _passwordCtrl,
//           keyboardType: TextInputType.visiblePassword,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           style: titleStyle,
//           decoration: InputDecoration(
//             labelText: 'Password',
//             suffix: IconButton(
//               onPressed: () => setState(() => _isObscure = !_isObscure),
//               icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
//             ),
//           ),
//           validator: (String? value) {
//             if (value == null) return null;
//             if (value.isEmpty) {
//               return 'Password can\'t be empty.';
//             } else if (value.length < 6) {
//               return 'Password must be at least 6 characters long.';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 10),
//         if (widget.create)
//           SwitchListTile(
//             value: _isAdmin,
//             contentPadding: EdgeInsets.zero,
//             title: const Text('Allow web portal access'),
//             controlAffinity: ListTileControlAffinity.leading,
//             onChanged: (_) => setState(() => _isAdmin = !_isAdmin),
//           )
//         else ...<Widget>[
//           CheckboxListTile(
//             value: _keepSigned,
//             contentPadding: EdgeInsets.zero,
//             activeColor: const Color(0xFF007AFF),
//             title: const Text('Keep me signed in.'),
//             controlAffinity: ListTileControlAffinity.leading,
//             onChanged: (_) => setState(() => _keepSigned = !_keepSigned),
//           ),
//           FittedBox(
//             child: _isCreate
//                 ? ButtonTile.two(
//                     left: const Icon(Icons.check),
//                     right: const Text(
//                       'Already have an account? Sign in.',
//                       style: TextStyle(letterSpacing: 0.5),
//                     ),
//                     onPressed: () => setState(() => _isCreate = !_isCreate),
//                   )
//                 : ButtonTile.two(
//                     left: const Icon(Icons.add),
//                     right: const Text(
//                       'Don\'t have an account? Sign up.',
//                       style: TextStyle(letterSpacing: 0.5),
//                     ),
//                     onPressed: () => setState(() => _isCreate = !_isCreate),
//                   ),
//           ),
//         ],
//         const SizedBox(height: 10),
//         Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
//           AnimatedSwitcher(
//             duration: const Duration(seconds: 1),
//             child: _isBusy
//                 ? ButtonTile.loading()
//                 : ButtonTile.two(
//                     left: Icon(_isCreate ? Icons.add : Icons.send),
//                     right: const Text('Please wait...'),
//                     onPressed: _authenticate,
//                   ),
//           ),
//         ]),
//       ],
//     );
//   }
// }

// extension on LoginScreenState {
//   Future<void> _authenticate() async {
//     _setState(isBusy: true);
//     try {
//       final UserCredential credential = await _loginOrRegister();
//       if (credential.user != null) {
//         if (widget.create) {
//           await _onRegister(credential.user!);
//         } else {
//           await _onLogin(credential.user!);
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       _setState(
//         isBusy: false,
//         message: firebaseErrors[e.code] ?? 'Unable to reach the internet.',
//       );
//     }
//   }

//   Future<UserCredential> _loginOrRegister() async {
//     if (_isCreate || (kIsWeb && widget.create)) {
//       return FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailCtrl.text,
//         password: _passwordCtrl.text,
//       );
//     }
//     return FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: _emailCtrl.text,
//       password: _passwordCtrl.text,
//     );
//   }

//   Future<void> _createUserEntry() async {
//     final DocumentReference<Patient> doc = dbRoot.doc(_emailCtrl.text);
//     final DocumentSnapshot<Patient> patient = await doc.get();
//     if (!patient.exists) {
//       final Prescription p = Prescription.create();
//       final Patient user = Patient(prescription: p);
//       await doc.set(user);
//     }
//   }

//   Future<void> _onRegister(User user) async {
//     await _createUserEntry();
//     _setState(isBusy: false, message: 'User created successfully!');
//     _emailCtrl.clear();
//     _passwordCtrl.clear();
//   }

//   Future<void> _onLogin(User user) async {
//     _userState!
//       ..keepSigned = _keepSigned
//       ..userName = _emailCtrl.text
//       ..passWord = _passwordCtrl.text;
//     if (_userState!.isInBox) {
//       await _userState!.save();
//     } else {
//       await boxUserState.put(keyUserStateBox, _userState!);
//     }
//     final SettingsState newSettingsState = boxSettingsState.get(
//       _emailCtrl.text,
//       defaultValue: SettingsState(),
//     )!;
//     if (!newSettingsState.isInBox) {
//       await boxSettingsState.put(_emailCtrl.text, newSettingsState);
//       await _createUserEntry();
//     }
//     try {
//       final Patient patientAsUser = await Patient.of(_emailCtrl.text).fetch();
//       newSettingsState.toggle(
//         isCustom: newSettingsState.customPrescriptions!,
//         prescription: patientAsUser.prescription!,
//       );
//       settingsState = newSettingsState;
//       patient = patientAsUser;
//       userState = _userState;
//       if (mounted) const HomePageRoute().push(context);
//     } on Exception {
//       _setState(
//         isBusy: false,
//         message: 'Opps!!! Something want wrong.',
//       );
//     }
//   }
// }

// extension on Null {
//   // viewed
//   Future<double?> _selectPain() {
//     double value = 0;
//     return AlertWidget.show<double>(
//       context: context,
//       title: 'Pain score (0 - 10)',
//       action: CustomWidget.two(
//         onPressed: () => GoRouter.of(context).pop<double>(value),
//         left: const Text('Next'),
//         right: const Icon(Icons.arrow_forward),
//       ),
//       content: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(children: <Widget>[
//           const Text(
//             'Please describe your pain during that session',
//             textAlign: TextAlign.center,
//             style: Styles.titleStyle,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: StatefulBuilder(
//               builder: (_, void Function(void Function()) setState) {
//                 return SliderWidget(
//                   value: value,
//                   onChanged: (double newValue) =>
//                       setState(() => value = newValue),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               _buildPainText('0\n\nNo\npain', const Color(0xff00e676)),
//               _buildPainText('5\n\nModerate\npain', const Color(0xff7f9c61)),
//               _buildPainText('10\n\nWorst\npain', const Color(0xffff534d)),
//             ],
//           ),
//         ]),
//       ),
//     );
//   }

//   // viewed
//   Text _buildPainText(String text, Color color) {
//     return Text(
//       text,
//       textAlign: TextAlign.center,
//       style: TextStyle(
//         color: color,
//         letterSpacing: 1,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }

//   // viewed
//   Future<String?> _selectTolerance() {
//     return AlertWidget.show<String>(
//       context: context,
//       title: 'Pain Tolerance',
//       content: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(children: <Widget>[
//           const Text(
//             'Was the pain during that session tolerable for you?',
//             textAlign: TextAlign.center,
//             style: Styles.titleStyle,
//           ),
//           const SizedBox(height: 16),
//           FittedBox(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 CustomWidget.two(
//                   left: const Icon(Icons.check, color: Color(0xff3ddc85)),
//                   right: const Text(
//                     'Yes',
//                     style: TextStyle(color: Color(0xff3ddc85)),
//                   ),
//                   onPressed: () => GoRouter.of(context).pop<String>('Yes'),
//                 ),
//                 const SizedBox(width: 5),
//                 CustomWidget.two(
//                   left: const Icon(Icons.clear, color: Color(0xffff534d)),
//                   right: const Text(
//                     'No',
//                     style: TextStyle(color: Color(0xffff534d)),
//                   ),
//                   onPressed: () => GoRouter.of(context).pop<String>('No'),
//                 ),
//                 const SizedBox(width: 5),
//                 CustomWidget.two(
//                   left: const Text('No pain'),
//                   right: const Icon(Icons.arrow_forward),
//                   onPressed: () => GoRouter.of(context).pop<String>('No pain'),
//                 ),
//               ],
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   // viewed
//   Future<bool?> _confirmSubmit() async {
//     return AlertWidget.show<bool>(
//       context: context,
//       title: 'Submit data?',
//       action: CustomWidget.two(
//         left: const Text('Discard'),
//         right: const Icon(Icons.clear, color: Color(0xffff534d)),
//         onPressed: () => GoRouter.of(context).pop(true),
//       ),
//       content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//         CustomWidget.two(
//           left: const Icon(Icons.cloud_upload, color: Color(0xff3ddc85)),
//           right: const Text('Submit Now'),
//           onPressed: () async {
//             GoRouter.of(context).pop(true);
//             await export!.upload();
//           },
//         ),
//         CustomWidget.two(
//           left: const Icon(Icons.save, color: Color(0xffe18f3c)),
//           right: const Text('Do it later'),
//           onPressed: () => GoRouter.of(context).pop(false),
//         ),
//       ]),
//     );
//   }
// // viewed
// Future<void> congratulate() async {
//   return AlertWidget.show<void>(
//     context: context,
//     title: 'Congratulations!',
//     action: CustomWidget.two(
//       onPressed: context.pop,
//       left: const Text('Next'),
//       right: const Icon(Icons.arrow_forward),
//     ),
//     content: const Padding(
//       padding: EdgeInsets.all(16),
//       child: Text(
//         'Exercise session completed.\nGreat work!!!',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 20,
//           color: Color(0xff3ddc85),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }
// }
