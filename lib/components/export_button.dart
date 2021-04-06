import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/utils/storage.dart';

<<<<<<< Updated upstream
class ExportButton extends StatelessWidget {
  const ExportButton({Key/*?*/ key, /*required*/ @required this.callback}) : super(key: key);
=======
class ExportButton extends StatelessWidget with Storage {
  const ExportButton({Key key, @required this.callback}) : super(key: key);
>>>>>>> Stashed changes

  final Future<UploadTask> Function() callback;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Export',
      icon: Icons.backup_rounded,
      onPressed: () async {
        final UploadTask _task = await callback();
        final bool _result = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierColor: Theme.of(context).primaryColor,
          builder: (BuildContext context) {
            return StreamBuilder<TaskSnapshot>(
              initialData: null,
              stream: _task.snapshotEvents,
              builder: (_, AsyncSnapshot<TaskSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.state == TaskState.success) Navigator.pop<bool>(context, true);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[CircularProgressIndicator(), Text('Please wait...', style: TextStyle(fontSize: 20))],
                );
              },
            );
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_result ? 'Data exported successfully!' : 'Something wants wrong!')));
      },
    );
  }
}
