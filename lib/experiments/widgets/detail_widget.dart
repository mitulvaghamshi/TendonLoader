import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/experimentutils.dart';

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
        itemBuilder: (_, snapshot) {
          var export = snapshot.data();
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
    var user = '${export.userId}-${export.timestamp?.millisecondsSinceEpoch}'
        .replaceAll('@', '');
    var map = export.toMap();
    var data = map.remove('"$keyExportData"').toString();

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
    var bytes = utf8.encode(value);
    var base64 = base64Encode(bytes);
    return 'data:application/zip;base64,$base64';
  }
}
