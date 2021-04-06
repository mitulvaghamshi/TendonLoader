import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage, Reference, SettableMetadata, UploadTask;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

mixin Storage {
  static Future<UploadTask> uploadFile(final File file, final String userID, final String name) async {
    if (!file.existsSync()) return null;
    final Reference reference = FirebaseStorage.instance.ref().child('all-users').child(userID).child('/$name');
    final SettableMetadata metadata = SettableMetadata(
      contentEncoding: 'utf-8',
      customMetadata: <String, String>{'Location': file.uri.toString()},
      contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    return Future<UploadTask>.value(
      kIsWeb ? reference.putData(await file.readAsBytes(), metadata) : reference.putFile(File(file.path), metadata),
    );
  }

  static Future<List<Reference>> getUserList({String path = 'all-users'}) async => (await FirebaseStorage.instance.ref(path).listAll()).prefixes;

  static Future<List<Reference>> getUserData(String path) async => (await FirebaseStorage.instance.ref(path).listAll()).items;

// // _downloadBytes(_uploadTasks[index].snapshot.ref) // kIsWeb
// Future<void> _downloadBytes(Reference ref) async {
//   // final bytes = await ref.getData();
//   // await saveAsBytes(bytes, 'some-image.jpg');
// }

// // _downloadFile(_uploadTasks[index].snapshot.ref) // !kIsWeb
// Future<void> _downloadFile(Reference ref) async {
//   final Directory sysTmpDir = Directory.systemTemp;
//   final File tempFile = File('${sysTmpDir.path}/temp-${ref.name}');
//   if (tempFile.existsSync()) await tempFile.delete();
//   await ref.writeToFile(tempFile);
// }

// // _downloadLink(_uploadTasks[index].snapshot.ref)
// Future<void> _downloadLink(Reference ref) async => Clipboard.setData(ClipboardData(text: await ref.getDownloadURL()));
}
