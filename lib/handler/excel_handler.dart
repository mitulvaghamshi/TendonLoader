import 'dart:convert' show base64;

import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/app_state/export.dart';
import 'package:tendon_loader/custom/empty.dart' if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';

void generateExcel(Export export) {
  int iR = 0;
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  // date
  iR++; // 1
  sheet.getRangeByIndex(iR, 1).text = 'Date:';
  sheet.getRangeByIndex(iR, 4).dateTime = export.timestamp.toDate();
  sheet.getRangeByIndex(iR, 4).numberFormat = 'yyyy-mmm-dd, dddd';

  // time
  iR++; // 2
  sheet.getRangeByIndex(iR, 1).text = 'Time:';
  sheet.getRangeByIndex(iR, 4).dateTime = export.timestamp.toDate();
  sheet.getRangeByIndex(iR, 4).numberFormat = 'hh:mm:ss AM/PM';

  // user id
  iR++; // 3
  sheet.getRangeByIndex(iR, 1).text = 'User ID:';
  sheet.getRangeByIndex(iR, 4).text = export.userId;

  // progressor id
  iR += 2; // 5
  sheet.getRangeByIndex(iR, 1).text = 'Progressor ID:';
  sheet.getRangeByIndex(iR, 4).text = export.progressorId;

  if (!export.isMVC) {
    final Prescription pre = export.prescription!;
    // Exercise info
    iR += 2; // 7
    sheet.getRangeByIndex(iR, 1).text = 'Exercise Info';

    // Last MVC test recorded
    iR++; // 8
    sheet.getRangeByIndex(iR, 1).text = 'Last MVC Test Recorded [Kg]';
    // TODO(me): adjust last recorded MVC
    sheet.getRangeByIndex(iR, 4).number = 0;

    // Target Load
    iR++; // 9
    sheet.getRangeByIndex(iR, 1).text = 'Target Load [Kg]';
    sheet.getRangeByIndex(iR, 4).number = pre.targetLoad;

    // Hold Time
    iR++; // 10
    sheet.getRangeByIndex(iR, 1).text = 'Hold Time [Sec]';
    sheet.getRangeByIndex(iR, 4).number = pre.holdTime.toDouble();

    // Rest Time
    iR++; // 11
    sheet.getRangeByIndex(iR, 1).text = 'Rest Time [Sec]';
    sheet.getRangeByIndex(iR, 4).number = pre.restTime.toDouble();

    // Sets
    iR++; // 12
    sheet.getRangeByIndex(iR, 1).text = 'Sets [#]';
    sheet.getRangeByIndex(iR, 4).number = pre.sets.toDouble();

    // Reps
    iR++; // 13
    sheet.getRangeByIndex(iR, 1).text = 'Reps [#]';
    sheet.getRangeByIndex(iR, 4).number = pre.reps.toDouble();
  }

  // data headers
  iR += 2; // 15
  sheet.getRangeByIndex(iR, 1).setText('TIME [s]');
  sheet.getRangeByIndex(iR, 2).setText('LOAD [Kg]');

  for (final ChartData chartData in export.exportData) {
    iR++; // 16..N
    sheet.getRangeByIndex(iR, 1).number = chartData.time;
    sheet.getRangeByIndex(iR, 2).number = chartData.load;
  }

  AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(workbook.saveAsStream())}')
    ..setAttribute('download', export.fileName)
    ..click();

  workbook.dispose();
}
