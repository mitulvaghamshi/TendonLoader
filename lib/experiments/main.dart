import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/experimentfirebase_options.dart';
import 'package:tendon_loader/experimentwidgets/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.macos);
  runApp(const MyApp());
}

@immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: SignIn());
}
