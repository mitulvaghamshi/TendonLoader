import 'package:archive/archive_io.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';

ArchiveFile generateExcel(Export export) {
  final Workbook _book = Workbook();
  final Worksheet _sheet = _book.worksheets[0];

  const int c4 = 4, c5 = 5;
  _sheet
    ..getRangeByIndex(1, 1).setText('TIME [s]')
    ..getRangeByIndex(1, 2).setText('LOAD [Kg]')
    ..getRangeByIndex(1, c4).text = 'Date:'
    ..getRangeByIndex(1, c5).dateTime = export.timestamp!.toDate()
    ..getRangeByIndex(1, c5).numberFormat = 'yyyy-mmm-dd, dddd'
    ..getRangeByIndex(2, c4).text = 'Time:'
    ..getRangeByIndex(2, c5).dateTime = export.timestamp!.toDate()
    ..getRangeByIndex(2, c5).numberFormat = 'hh:mm:ss AM/PM'
    ..getRangeByIndex(3, c4).text = 'User ID:'
    ..getRangeByIndex(3, c5).text = export.userId
    ..getRangeByIndex(4, c4).text = 'Progressor ID:'
    ..getRangeByIndex(4, c5).text = export.progressorId
    ..getRangeByIndex(6, c4).text = 'Pain Score:'
    ..getRangeByIndex(6, c5).text = export.painScore?.toString() ?? '---'
    ..getRangeByIndex(7, c4).text = 'Pain Tolerable?:'
    ..getRangeByIndex(7, c5).text = export.isTolerable
    ..autoFitColumn(c4)
    ..autoFitColumn(c5);

  if (!export.isMVC) {
    _sheet
      ..getRangeByIndex(9, c4).text = 'Exercise Info'
      ..getRangeByIndex(10, c4).text = 'Target Load [Kg]'
      ..getRangeByIndex(10, c5).number = export.prescription!.targetLoad
      ..getRangeByIndex(11, c4).text = 'Hold Time [Sec]'
      ..getRangeByIndex(11, c5).number = export.prescription!.holdTime.toDouble()
      ..getRangeByIndex(12, c4).text = 'Rest Time [Sec]'
      ..getRangeByIndex(12, c5).number = export.prescription!.restTime.toDouble()
      ..getRangeByIndex(13, c4).text = 'Sets [#]'
      ..getRangeByIndex(13, c5).number = export.prescription!.sets.toDouble()
      ..getRangeByIndex(14, c4).text = 'Reps [#]'
      ..getRangeByIndex(14, c5).number = export.prescription!.reps.toDouble();
  }

  int i = 1;
  for (final ChartData chartData in export.exportData!) {
    _sheet
      ..getRangeByIndex(++i, 1).number = chartData.time
      ..getRangeByIndex(i, 2).number = chartData.load;
  }

  final InputStream _stream = InputStream(_book.saveAsStream());
  final ArchiveFile _file = ArchiveFile.stream(export.fileName, _stream.length, _stream);
  _book.dispose();

  return _file;
}
