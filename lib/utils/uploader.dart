import 'dart:async';
import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart' show /*UploadTask,*/ Reference, FirebaseStorage, SettableMetadata /*, TaskSnapshot, TaskState*/;
import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

class Uploader {
  // final List<UploadTask> _uploadTasks = <UploadTask>[];

  Future<void> _uploadFile(final File file, final String userID, final String name) async {
    final Reference reference = FirebaseStorage.instance.ref().child('all-users').child(userID).child('/$name');
    final SettableMetadata metadata = SettableMetadata(
      contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      customMetadata: <String, String>{'Source Location': file.uri.toString()},
    );
    kIsWeb ? await reference.putData(await file.readAsBytes(), metadata) : await reference.putFile(file, metadata);
  }

  // // _downloadBytes(_uploadTasks[index].snapshot.ref) // kIsWeb
  // Future<void> _downloadBytes(Reference ref) async {
  //   // final bytes = await ref.getData();
  //   // await saveAsBytes(bytes, 'some-image.jpg');
  // }
  //
  // // _downloadFile(_uploadTasks[index].snapshot.ref) // !kIsWeb
  // Future<void> _downloadFile(Reference ref) async {
  //   final Directory sysTmpDir = Directory.systemTemp;
  //   final File tempFile = File('${sysTmpDir.path}/temp-${ref.name}');
  //   if (tempFile.existsSync()) await tempFile.delete();
  //   await ref.writeToFile(tempFile);
  // }
  //
  // // _downloadLink(_uploadTasks[index].snapshot.ref)
  // Future<void> _downloadLink(Reference ref) async => Clipboard.setData(ClipboardData(text: await ref.getDownloadURL()));

  Future<void> createTask(File file, String userID, String name) async {
    if (file.existsSync()) await _uploadFile(file, userID, name);
  }
}

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
