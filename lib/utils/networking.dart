import 'dart:async';
import 'dart:io' show File, Directory;

import 'package:firebase_storage/firebase_storage.dart' show UploadTask, Reference, FirebaseStorage, SettableMetadata, TaskSnapshot, TaskState;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as pp;

class TaskManager extends StatefulWidget {
  const TaskManager({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskManager();
}

class _TaskManager extends State<TaskManager> {
  final List<UploadTask> _uploadTasks = <UploadTask>[];

  Future<UploadTask> _uploadFile(File file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file was selected')));
      return null;
    }
    // TODO(mitul): variable folder name and file name of course
    final Reference ref = FirebaseStorage.instance.ref().child('playground').child('/export-name.xlsx');
    final SettableMetadata metadata = SettableMetadata(
      contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      customMetadata: <String, String>{'Source Location': file.uri.toString()},
    );
    return Future<UploadTask>.value(
      kIsWeb ? ref.putData(await file.readAsBytes(), metadata) : ref.putFile(File(file.path), metadata),
    );
  }

  Future<void> _downloadBytes(Reference ref) async {
    // final bytes = await ref.getData();
    // await saveAsBytes(bytes, 'some-image.jpg');
  }

  Future<void> _downloadFile(Reference ref) async {
    final Directory sysTmpDir = Directory.systemTemp;
    final File tempFile = File('${sysTmpDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();
    await ref.writeToFile(tempFile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
          'at path: ${ref.fullPath} \n'
          'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
        ),
      ),
    );
  }

  Future<void> _downloadLink(Reference ref) async {
    final String link = await ref.getDownloadURL();
    await Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success!\n Copied download URL to Clipboard!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Example App')),
      body: _uploadTasks.isEmpty
          ? Center(
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final String _path = (await pp.getExternalStorageDirectory()).path;
                  const String _name = 'UserID_ExerciseMode.xlsx';
                  final File _file = File('$_path/$_name');
                  if (_file.existsSync()) {
                    final UploadTask task = await _uploadFile(_file);
                    setState(() => _uploadTasks.add(task));
                    // ignore: avoid_print
                    print('file exist');
                  }
                },
              ),
            )
          : ListView.builder(
              itemCount: _uploadTasks.length,
              itemBuilder: (BuildContext context, int index) => UploadTaskListTile(
                task: _uploadTasks[index],
                onDismissed: () {},
                onDownloadLink: () => _downloadLink(_uploadTasks[index].snapshot.ref),
                onDownload: () => kIsWeb ? _downloadBytes(_uploadTasks[index].snapshot.ref) : _downloadFile(_uploadTasks[index].snapshot.ref),
              ),
            ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile({
    Key key,
    this.task,
    this.onDownload,
    this.onDismissed,
    this.onDownloadLink,
  }) : super(key: key);

  final UploadTask /*!*/ task;
  final VoidCallback /*!*/ onDownload;
  final VoidCallback /*!*/ onDismissed;
  final VoidCallback /*!*/ onDownloadLink;

  String _bytesTransferred(TaskSnapshot snapshot) => '${snapshot.bytesTransferred}/${snapshot.totalBytes}';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle = const Text('---');
        final TaskSnapshot snapshot = asyncSnapshot.data;
        final TaskState state = snapshot?.state;
        if (asyncSnapshot.hasError) {
          // ignore: avoid_print
          print(asyncSnapshot.error);
        } else if (snapshot != null) {
          subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (DismissDirection direction) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <IconButton>[
                if (state == TaskState.paused) IconButton(icon: const Icon(Icons.file_upload), onPressed: task.resume),
                if (state == TaskState.running) IconButton(icon: const Icon(Icons.pause), onPressed: task.pause),
                if (state == TaskState.running) IconButton(icon: const Icon(Icons.cancel), onPressed: task.cancel),
                if (state == TaskState.success) IconButton(icon: const Icon(Icons.file_download), onPressed: onDownload),
                if (state == TaskState.success) IconButton(icon: const Icon(Icons.link), onPressed: onDownloadLink),
              ],
            ),
          ),
        );
      },
    );
  }
}
