import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileSaveHelper {
  static const MethodChannel _platformCall = MethodChannel('launchFile');

  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    final Map<String, String> argument = <String, String>{'file_path': '$path/$fileName'};
    try {
      final Future<Map<String, String>> result = _platformCall.invokeMethod('viewExcel', argument);
      // ignore: avoid_print
      print(result);
    } catch (e) {
      throw Exception(e);
    }
  }
}
