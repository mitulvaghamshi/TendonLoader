import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/experiments/widgets/signin.dart';
import 'package:tendon_loader/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.macos);
  FirebaseUIAuth.configureProviders(
      <AuthProvider<AuthListener, AuthCredential>>[EmailAuthProvider()]);
  runApp(const MyApp());
}

@immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: SignIn());
}
