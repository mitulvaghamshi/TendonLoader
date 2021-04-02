import 'dart:io' show File;

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/chart_data.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/exercise_data.dart';
import 'package:tendon_loader/utils/uploader.dart';

mixin CreateXLSX {
  static final List<ChartData> _collection = <ChartData>[];

  void collect(ChartData chartData) => _collection.add(chartData);

  Future<void> export({ExerciseData exerciseData}) async {
    // if (_measurements.isEmpty) return;
    int _iR = 0;
    const String _iA = 'A';
    const String _iD = 'D';
    final Workbook _workbook = Workbook();
    final DateTime _dtNow = DateTime.now();
    final String _date = DateFormat('y-MM-d').format(_dtNow);
    final String _time = DateFormat('hh:mm a').format(_dtNow);
    final bool isExercise = exerciseData != null;
    final Worksheet _sheet = _workbook.worksheets[0];
    final String _userId = (await SharedPreferences.getInstance()).getString(Keys.keyUsername);

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
    _sheet.getRangeByName('$_iA$_iR').text = 'UserID:';
    _sheet.getRangeByName('$_iD$_iR').text = _userId;

    // progressor id
    _iR += 2; // 5
    _sheet.getRangeByName('$_iA$_iR').text = 'Tindeq Progressor #:';
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
      _sheet.getRangeByName('$_iA$_iR').text = 'Hold Time [sec]';
      _sheet.getRangeByName('$_iD$_iR').number = exerciseData.holdTime.toDouble();

      // Rest Time
      _iR++; // 11
      _sheet.getRangeByName('$_iA$_iR').text = 'Rest Time [sec]';
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

    int count = 0;
    double _avgTime = 0;
    double _avgWeight = 0;
    for (final ChartData chartData in _collection) {
      _avgTime += chartData.time;
      _avgWeight += chartData.weight;
      if (count++ == 8) {
        _iR++; // 16..N
        _sheet.getRangeByName('$_iA$_iR').number = double.parse(((_avgTime / 8.0) / 1000000.0).toStringAsFixed(2));
        _sheet.getRangeByName('B$_iR').number = double.parse((_avgWeight.abs() / 8.0).toStringAsFixed(2));
        _avgWeight = _avgTime = 0;
        count = 0;
      }
    }
    _collection.clear();

    final String _mode = isExercise ? 'Exercise' : 'MVCTest';
    final String _path = (await pp.getApplicationSupportDirectory()).path;
    final String _name = '${_date}_${_time.replaceAll(RegExp(r'[\s:]'), '_')}_${_userId.split('@')[0]}_$_mode.xlsx';
    final File _file = File('$_path/$_name');
    await _file.writeAsBytes(_workbook.saveAsStream());
    _workbook.dispose();
    await Uploader.uploadFile(_file, _userId.split('@')[0], _name);
  }
}
