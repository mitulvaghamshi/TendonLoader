import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/ui/widgets/anchor_element.dart'
    if (dart.library.html) 'dart:html'
    show AnchorElement;

Future<void> saveExcel({required String name, List<int>? bytes}) async {
  if (bytes == null || bytes.isEmpty) {
    return;
  }
  if (!kIsWeb) {
    throw 'Downloading not supported for mobile/desktop devices';
  }
  AnchorElement(href: 'data:application/zip;base64,${base64Encode(bytes)}')
    ..setAttribute('download', name)
    ..click();
}
