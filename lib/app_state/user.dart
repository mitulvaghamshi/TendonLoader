import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/export.dart';
import 'package:tendon_loader/handler/excel_handler.dart';
import 'package:tendon_loader/web_portal/export_list_item.dart';

class User {
  const User({required this.exports, required this.reference});

  final List<Export>? exports;
  final DocumentReference<Map<String, dynamic>> reference;

  int? get exportCount => exports?.length;
  String get id => reference.id.toString();
  String get avatar => id[0].toLowerCase();
  Iterable<Widget> get exportTiles => exports!.map((Export export) => ExportListItem(export: export));

  // long task
  Future<void> download() async {
    exports!.forEach(generateExcel);
  }
}
