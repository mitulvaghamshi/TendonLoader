import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/utils/keys.dart';

final CollectionReference<User> dbRoot = FirebaseFirestore.instance.collection(keyBase).withConverter<User>(
    toFirestore: (User value, _) => value.toMap(),
    fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => User.fromJson(snapshot.reference));
