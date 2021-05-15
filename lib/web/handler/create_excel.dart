import 'dart:convert';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:tendon_loader/shared/constants.dart' show Keys;
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';
import 'package:tendon_loader/web/empty.dart' if (dart.library.html) 'dart:html'
    show AnchorElement;

mixin CreateExcel {
  void create(
      {List<ChartData> data,
      SessionInfo sessionInfo,
      Prescription prescription}) {
    int _iR = 0;
    const String _iA = 'A';
    const String _iD = 'D';
    final Workbook _workbook = Workbook();
    final Worksheet _sheet = _workbook.worksheets[0];

    // date
    _iR++; // 1
    _sheet.getRangeByName('$_iA$_iR').text = 'Date:';
    _sheet.getRangeByName('$_iD$_iR').text = sessionInfo.exportDate;
    _sheet.getRangeByName('$_iD$_iR').numberFormat = 'yyyy-mmm-dd, dddd';

    // time
    _iR++; // 2
    _sheet.getRangeByName('$_iA$_iR').text = 'Time:';
    _sheet.getRangeByName('$_iD$_iR').text = sessionInfo.exportTime;
    _sheet.getRangeByName('$_iD$_iR').numberFormat = 'hh:mm:ss AM/PM';

    // user id
    _iR++; // 3
    _sheet.getRangeByName('$_iA$_iR').text = 'User ID:';
    _sheet.getRangeByName('$_iD$_iR').text = sessionInfo.userId;

    // progressor id
    _iR += 2; // 5
    _sheet.getRangeByName('$_iA$_iR').text = 'Progressor ID:';
    _sheet.getRangeByName('$_iD$_iR').text = sessionInfo.progressorId;

    if (sessionInfo.exportType == Keys.KEY_PREFIX_EXERCISE) {
      // Exercise info
      _iR += 2; // 7
      _sheet.getRangeByName('$_iA$_iR').text = 'Exercise Info';

      // Last MVC test recorded
      _iR++; // 8
      _sheet.getRangeByName('$_iA$_iR').text = 'Last MVC Test Recorded [Kg]';
      // TODO(mitul): adjust last recorded MVC
      _sheet.getRangeByName('$_iD$_iR').number = prescription.lastMVC;

      // Target Load
      _iR++; // 9
      _sheet.getRangeByName('$_iA$_iR').text = 'Target Load [Kg]';
      _sheet.getRangeByName('$_iD$_iR').number = prescription.targetLoad;

      // Hold Time
      _iR++; // 10
      _sheet.getRangeByName('$_iA$_iR').text = 'Hold Time [Sec]';
      _sheet.getRangeByName('$_iD$_iR').number =
          prescription.holdTime.toDouble();

      // Rest Time
      _iR++; // 11
      _sheet.getRangeByName('$_iA$_iR').text = 'Rest Time [Sec]';
      _sheet.getRangeByName('$_iD$_iR').number =
          prescription.restTime.toDouble();

      // Sets
      _iR++; // 12
      _sheet.getRangeByName('$_iA$_iR').text = 'Sets [#]';
      _sheet.getRangeByName('$_iD$_iR').number = prescription.sets.toDouble();

      // Reps
      _iR++; // 13
      _sheet.getRangeByName('$_iA$_iR').text = 'Reps [#]';
      _sheet.getRangeByName('$_iD$_iR').number = prescription.reps.toDouble();
    }

    // data headers
    _iR += 2; // 15
    _sheet.getRangeByName('$_iA$_iR').setText('TIME [s]');
    _sheet.getRangeByName('B$_iR').setText('LOAD [Kg]');

    for (final ChartData chartData in data) {
      _iR++; // 16..N
      _sheet.getRangeByName('$_iA$_iR').number = chartData.time;
      _sheet.getRangeByName('B$_iR').number = chartData.load;
    }

    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(_workbook.saveAsStream())}')
      ..setAttribute('download', sessionInfo.fileName)
      ..click();

    _workbook.dispose();
  }
}
