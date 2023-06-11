import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/export.dart';
import 'package:tendon_loader/firebase_options.dart';
import 'package:tendon_loader/patient.dart';
import 'package:tendon_loader/utils.dart';

Future<void> _useEmulator() async {
  const String host = '127.0.0.1';
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) _useEmulator();
  FirebaseUIAuth.configureProviders(
      <AuthProvider<AuthListener, AuthCredential>>[EmailAuthProvider()]);
  runApp(const MyApp());
}

@immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) return const ListWidget();
          return const SignInScreen(email: 'alexscott@tendonloader.com');
        },
      ),
    );
  }
}

@immutable
class ListWidget extends StatelessWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiments')),
      floatingActionButton: FloatingActionButton(
        onPressed: FirebaseAuth.instance.signOut,
        child: const Icon(Icons.logout),
      ),
      body: FirestoreListView<Patient>(
        query: query,
        itemBuilder: (_, QueryDocumentSnapshot<Patient> doc) =>
            ItemWidget(patient: doc.data()),
      ),
    );
  }
}

@immutable
class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final List<String>? names = patient.patientRef?.id.split('@');
    if (names == null) throw 'Document name is null.';
    return ListTile(
      leading: CircleAvatar(child: Text(names.first[0].toUpperCase())),
      title: Text(names.first),
      subtitle: Text(names.join('@')),
      onTap: () {
        // uploadToFirebase(patient);
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => DetailWidget(item: patient)),
        );
      },
    );
  }
}

@immutable
class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key, required this.item});

  final Patient item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient details')),
      body: FirestoreListView<Export>(
        query: item.exportRef!,
        itemBuilder: (_, QueryDocumentSnapshot<Export> snapshot) {
          final Export export = snapshot.data();
          return ListTile(
            // onTap: () async => saveAsJson(export),
            leading: CircleAvatar(child: Text(export.isMVC ? 'MVC' : 'EXE')),
            title: Text(export.userId ?? 'Unidentified'),
            subtitle: Text(DateFormat('MMM dd, yyyy hh:mm a')
                .format(export.timestamp?.toDate() ?? DateTime.now())),
          );
        },
      ),
    );
  }
}
