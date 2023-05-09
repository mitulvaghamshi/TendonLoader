import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:tendon_loader/experimentutils.dart';
import 'package:tendon_loader/experimentwidgets/list_item.dart';

@immutable
class ListWidget extends StatelessWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader - Clinician')),
      body: FirestoreListView<Patient>(
        query: query,
        itemBuilder: (_, doc) => ItemWidget(patient: doc.data()),
      ),
    );
  }
}
