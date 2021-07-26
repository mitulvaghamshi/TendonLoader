import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/placeholder.dart' if (dart.library.html) 'dart:html' show AnchorElement;

@immutable
class Downloader {
  const Downloader({this.bytes});

  final List<int>? bytes;

  Future<void> download({required String name}) async {
    if (kIsWeb) {
      AnchorElement(href: 'data:application/zip;base64,${base64.encode(bytes!)}')
        ..setAttribute('download', name)
        ..click();
    } else if (Platform.isAndroid) {
      // File
    }
  }
}
