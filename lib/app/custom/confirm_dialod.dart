import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/app/custom/custom_listtile.dart';
import 'package:tendon_loader/app/handler/export_handler.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key key, this.model}) : super(key: key);

  final DataModel model;

  static Future<bool> show(BuildContext context, {DataModel model}) async {
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

  void _export(BuildContext context, [bool later = false]) {
    ExportHandler.export(model, later);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(later ? 'Saving...' : 'Uploading...')));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomTile(
          title: 'Submit now',
          onTap: () => _export(context),
          padding: const EdgeInsets.symmetric(vertical: 5),
          icon: const Icon(Icons.circle, color: Colors.green, size: 50),
          desc: 'Send data to the cloud. Requires an active internet connection.',
        ),
        CustomTile(
          title: 'Ask me later',
          onTap: () => _export(context, true),
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
