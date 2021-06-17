import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/app_state/export.dart';
import 'package:tendon_loader/constants/constants.dart'; 

class Base {
  Base({required this.export, required this.reference});

  Base.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this(
            reference: snapshot.reference,
            export: snapshot.reference.collection(keyExports).withConverter<Export>(
                toFirestore: (Export value, SetOptions? options) {
              return <String, Object>{};
            }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
              return Export.fromMap(snapshot);
            }));

  final CollectionReference<Export> export;
  final DocumentReference<Map<String, dynamic>> reference;
}
