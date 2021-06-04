import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_listtile.dart';
import 'package:tendon_loader/handler/export_handler.dart' show export;
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key, this.model}) : super(key: key);

  final DataModel? model;

  static Future<bool?> show(BuildContext context, {DataModel? model}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: ConfirmDialog(model: model),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Submit data to Clinician?', textAlign: TextAlign.center),
        actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))],
      ),
    );
  }

  Future<void> _export(BuildContext context, [bool later = false]) async {
    final bool result = await export(model!, later);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result
          ? later
              ? 'Data saved successfully...'
              : 'Data uploaded successfully...'
          : 'Something wants wrong...'),
    ));
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomTile(
          title: 'Submit now.',
          onTap: () async => _export(context),
          padding: const EdgeInsets.symmetric(vertical: 5),
          icon: const Icon(Icons.circle, color: Colors.green, size: 50),
          desc: 'Send data to the cloud. Requires an active internet connection.',
        ),
        CustomTile(
          title: 'Submit later.',
          onTap: () async => _export(context, true),
          padding: const EdgeInsets.symmetric(vertical: 5),
          icon: const Icon(Icons.circle, color: Colors.yellow, size: 50),
          desc: 'Save data locally on device and submit later (manual action required).',
        ),
        CustomTile(
          title: 'Discard!',
          onTap: () => Navigator.pop<bool>(context, false),
          padding: const EdgeInsets.symmetric(vertical: 5),
          icon: const Icon(Icons.circle, color: Colors.red, size: 50),
          desc: '(Attention!) Destroy data without submitting (cannot be recovered).',
        ),
      ],
    );
  }
}
