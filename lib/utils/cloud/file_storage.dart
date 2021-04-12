import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage, Reference, SettableMetadata, UploadTask;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

mixin FileStorage {
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

// class UploadTaskListTile extends StatelessWidget {
//   const UploadTaskListTile({Key key, this.task, this.onDownload, this.onDismissed, this.onDownloadLink}) : super(key: key);
//
//   final UploadTask task;
//   final VoidCallback onDownload;
//   final VoidCallback onDismissed;
//   final VoidCallback onDownloadLink;
//
//   String _bytesTransferred(TaskSnapshot snapshot) => '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<TaskSnapshot>(
//       stream: task.snapshotEvents,
//       builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
//         Widget subtitle = const Text('---');
//         final TaskSnapshot snapshot = asyncSnapshot.data;
//         final TaskState state = snapshot?.state;
//         if (snapshot != null) subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
//         return Dismissible(
//           key: Key(task.hashCode.toString()),
//           onDismissed: (DismissDirection direction) => onDismissed(),
//           child: ListTile(
//             title: Text('Upload Task #${task.hashCode}'),
//             subtitle: subtitle,
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <IconButton>[
//                 if (state == TaskState.paused) IconButton(icon: const Icon(Icons.file_upload), onPressed: task.resume),
//                 if (state == TaskState.running) IconButton(icon: const Icon(Icons.pause), onPressed: task.pause),
//                 if (state == TaskState.running) IconButton(icon: const Icon(Icons.cancel), onPressed: task.cancel),
//                 if (state == TaskState.success) IconButton(icon: const Icon(Icons.link), onPressed: onDownloadLink),
//                 if (state == TaskState.success) IconButton(icon: const Icon(Icons.file_download), onPressed: onDownload),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
}
