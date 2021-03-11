import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:tendon_loader/utils/chart_data.dart';

class CreateXLSX {
  const CreateXLSX({@required this.measurements}) : assert(measurements != null);

  final List<ChartData> measurements;

  Future generateExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    int _index = 15;

    sheet.getRangeByName('A$_index').setText('TIME [s]');
    sheet.getRangeByName('B$_index').setText('LOAD [Kg]');

    measurements.forEach((chartData) {
      _index++;
      sheet.getRangeByName('A$_index').setNumber(chartData.time);
      sheet.getRangeByName('B$_index').setNumber(chartData.weight);
    });

/*
    Range range1 = sheet.getRangeByName('A2');
    range1.dateTime = DateTime(2020, 08, 31);
    range1.columnWidth = 150;
    range1.autoFit();
    sheet.getRangeByName('A2').numberFormat = '[\$-x-sysdate]dddd, mmmm dd, yyyy';
*/

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    try {
      // final Directory directory = await pp.getApplicationSupportDirectory();
      final Directory directory = await pp.getExternalStorageDirectory();
      final String path = directory.path;
      String name = '${DateTime.now().toString().replaceAll(RegExp(r'[\.:]'), '_')}_UserID_ExerciseMode.xlsx';
      final File file = File('$path/$name');
      await file.exists().then((value) async {
        if (value) await file.delete();
      });
      await file.writeAsBytes(bytes);
    } on pp.MissingPlatformDirectoryException catch (e) {
      print(e);
    }
  }
}
