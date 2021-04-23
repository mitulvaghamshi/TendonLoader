import 'dart:async';
import 'dart:io' show File;

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';


mixin CreateExcel {
  Future<void> create({Prescription exerciseData, List<ChartData> data}) async {
    int _iR = 0;
    const String _iA = 'A';
    const String _iD = 'D';
    final Workbook _workbook = Workbook();
    final DateTime _dtNow = DateTime.now();
    final String _date = DateFormat('y-MM-d').format(_dtNow);
    final String _time = DateFormat('hh:mm a').format(_dtNow);
    final bool isExercise = exerciseData != null;
    final Worksheet _sheet = _workbook.worksheets[0];
    final String _userId = (await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX)).get(Keys.KEY_USERNAME) as String;

    // date
    _iR++; // 1
    _sheet.getRangeByName('$_iA$_iR').text = 'Date:';
    _sheet.getRangeByName('$_iD$_iR').text = _date;
    _sheet.getRangeByName('$_iD$_iR').numberFormat = 'yyyy-mmm-dd, dddd';

    // time
    _iR++; // 2
    _sheet.getRangeByName('$_iA$_iR').text = 'Time:';
    _sheet.getRangeByName('$_iD$_iR').text = _time;
    _sheet.getRangeByName('$_iD$_iR').numberFormat = 'hh:mm:ss AM/PM';

    // user id
    _iR++; // 3
    _sheet.getRangeByName('$_iA$_iR').text = 'User ID:';
    _sheet.getRangeByName('$_iD$_iR').text = _userId;

    // progressor id
    _iR += 2; // 5
    _sheet.getRangeByName('$_iA$_iR').text = 'Progressor ID:';
    _sheet.getRangeByName('$_iD$_iR').text = Bluetooth.deviceName ?? 'Device not connected';

    if (isExercise) {
      // Exercise info
      _iR += 2; // 7
      _sheet.getRangeByName('$_iA$_iR').text = 'Exercise Info';

      // Last MVC test recorded
      _iR++; // 8
      _sheet.getRangeByName('$_iA$_iR').text = 'Last MVC Test Recorded [Kg]';
      // TODO(mitul): adjust last recorded MVC
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.targetLoad * 1.3;

      // Target Load
      _iR++; // 9
      _sheet.getRangeByName('$_iA$_iR').text = 'Target Load [Kg]';
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.targetLoad;

      // Hold Time
      _iR++; // 10
      _sheet.getRangeByName('$_iA$_iR').text = 'Hold Time [Sec]';
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.holdTime.toDouble();

      // Rest Time
      _iR++; // 11
      _sheet.getRangeByName('$_iA$_iR').text = 'Rest Time [Sec]';
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.restTime.toDouble();

      // Sets
      _iR++; // 12
      _sheet.getRangeByName('$_iA$_iR').text = 'Sets [#]';
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.sets.toDouble();

      // Reps
      _iR++; // 13
      _sheet.getRangeByName('$_iA$_iR').text = 'Reps [#]';
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.reps.toDouble();
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

    final String _mode = isExercise ? 'Exercise' : 'MVCTest';
    final String _path = (await pp.getExternalStorageDirectory()).path;
    final String _name = '${_date}_${_time.replaceAll(RegExp(r'[\s:]'), '_')}_${_userId.split('@')[0]}_$_mode.xlsx';
    final File _file = File('$_path/$_name');
    await _file.writeAsBytes(_workbook.saveAsStream());
    _workbook.dispose();
    // FileStorage.uploadFile(_file, _userId.split('@')[0], _name);
  }
}
