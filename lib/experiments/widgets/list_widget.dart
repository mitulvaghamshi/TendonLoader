import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/experiments/utils.dart';
import 'package:tendon_loader/experiments/widgets/list_item.dart';

@immutable
class ListWidget extends StatelessWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader - Clinician')),
      body: FirestoreListView<Patient>(
        query: query,
        itemBuilder: (_, QueryDocumentSnapshot<Patient> doc) {
          return ItemWidget(patient: doc.data());
        },
      ),
    );
  }
}
