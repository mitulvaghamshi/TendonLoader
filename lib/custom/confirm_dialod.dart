import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/modal/export.dart';

@immutable
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key, this.export}) : super(key: key);

  final Export? export;

  static Future<bool?> show(BuildContext context, {Export? export}) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: ConfirmDialog(export: export),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Submit data to Clinician?', textAlign: TextAlign.center),
      ),
    );
  }

  Future<void> _startExport(BuildContext context, [bool later = false]) async {
    final bool result = await submit(context, export!, later);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result
            ? later
                ? 'Data saved successfully...'
                : 'Data uploaded successfully...'
            : 'Something wants wrong...')));
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () async => _startExport(context),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          leading: const Icon(Icons.circle, color: googleGreen, size: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          subtitle: const Text('Send data to the cloud. Requires an active internet connection.'),
          title: const Text('Submit now', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          onTap: () async => _startExport(context, true),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          leading: const Icon(Icons.circle, color: yellow400, size: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          subtitle: const Text('Save data locally on device and submit later (manual action required).'),
          title: const Text('Do it later', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          onTap: () async => Navigator.pop<bool>(context, false),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          leading: const Icon(Icons.circle, color: red400, size: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          subtitle: const Text('(Attention!) Destroy data without submitting (cannot be recovered).'),
          title: const Text('Discard!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
