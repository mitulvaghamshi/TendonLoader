import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/experiments/utils.dart';

@immutable
class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key, required this.item});

  final Patient item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient details')),
      body: FirestoreListView<Export>(
        query: item.exportRef!,
        itemBuilder: (_, QueryDocumentSnapshot<Export> snapshot) {
          final Export export = snapshot.data();
          return ListTile(
            onTap: () async => _saveAsJson(export),
            leading: CircleAvatar(child: Text(export.isMVC ? 'MVC' : 'EXE')),
            title: Text(export.userId ?? 'Unidentified'),
            subtitle: Text(DateFormat('MMM dd, yyyy hh:mm a')
                .format(export.timestamp?.toDate() ?? DateTime.now())),
          );
        },
      ),
    );
  }

  Future<void> _saveAsJson(Export export) async {
    final String user =
        '${export.userId}-${export.timestamp?.millisecondsSinceEpoch}'
            .replaceAll('@', '');
    final Map<String, dynamic> map = export.toMap();
    final String data = map.remove('"$keyExportData"').toString();

    if (kIsWeb) {
      AnchorElement(href: _encode(map.toString()))
        ..setAttribute('download', '$user-user.json')
        ..click();
      AnchorElement(href: _encode(data))
        ..setAttribute('download', '$user-data.json')
        ..click();
    } else {
      await (File('$user-user.json')..openWrite())
          .writeAsString(map.toString());
      await (File('$user-data.json')..openWrite()).writeAsString(data);
      return;
    }
  }

  String _encode(String value) {
    final List<int> bytes = utf8.encode(value);
    final String base64 = base64Encode(bytes);
    return 'data:application/zip;base64,$base64';
  }
}
