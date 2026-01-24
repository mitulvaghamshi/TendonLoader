import 'package:archive/archive_io.dart';
import 'package:server/models/chartdata.dart';
import 'package:server/models/exercise.dart';
import 'package:server/models/prescription.dart';
import 'package:server/models/user.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

typedef TableItem = ({String label, String value});

typedef ExerciseRecord = ({
  double targetLoad,
  Iterable<ChartData> chartData,
  Iterable<TableItem> infoTable,
});

Future<void> downloadUser(User user) async {
  throw UnimplementedError('Download not implemented.');
  // final Export query = exportRef!;
  // final Iterable<ArchiveFile> iterable =
  //     query.docs.map<ArchiveFile>((e) => e.toExcelSheet());
  // final Archive archive = Archive();
  // iterable.forEach(archive.addFile);
  // await saveExcel(name: '$id.zip', bytes: ZipEncoder().encode(archive));
}

Future<void> deleteUser(User user) async {
  throw UnimplementedError('Delete not implemented.');
  // final Export query = exportRef!;
  // query.docs.map((e) => e.reference.delete());
  // await reference!.delete();
}

Future<bool> uploadExercise(Exercise exercise) async {
  throw UnimplementedError('Upload not implemented.');
  // try {
  //   if (userId == -1) throw 'Invalid patient id!';
  //   return true;
  // } on Exception {
  //   return false;
  // }
}

Future<void> downloadExercise(Exercise exercise) async {
  throw UnimplementedError('Upload not implemented.');
  // await saveExcel(
  //   name: '$datetime-$userId.zip'.replaceAll(RegExp('[@:,]'), ''),
  //   bytes: ZipEncoder().encode(
  //     Archive()..addFile(_excelSheet(const Prescription.empty())),
  //   ),
  // );
}

ArchiveFile exportToExcel(Exercise exercise, [Prescription? prescription]) {
  final book = Workbook();
  final sheet = book.worksheets[0];
  const c4 = 4, c5 = 5;

  sheet
    ..getRangeByIndex(1, 1).setText('TIME [s]')
    ..getRangeByIndex(1, 2).setText('LOAD [Kg]')
    ..getRangeByIndex(1, c4).text = 'Date:'
    ..getRangeByIndex(1, c5).text = exercise.datetime
    ..getRangeByIndex(1, c5).numberFormat = 'yyyy-mmm-dd, dddd'
    ..getRangeByIndex(2, c4).text = 'Time:'
    ..getRangeByIndex(2, c5).text = exercise.datetime
    ..getRangeByIndex(2, c5).numberFormat = 'hh:mm:ss AM/PM'
    ..getRangeByIndex(3, c4).text = 'User ID:'
    ..getRangeByIndex(3, c5).text = exercise.userId.toString()
    ..getRangeByIndex(4, c4).text = 'Progressor ID:'
    ..getRangeByIndex(4, c5).text = exercise.progressorId
    ..getRangeByIndex(4, c5).text = exercise.prescriptionId.toString()
    ..getRangeByIndex(6, c4).text = 'Pain Score:'
    ..getRangeByIndex(6, c5).text = exercise.painScore.toString()
    ..getRangeByIndex(7, c4).text = 'Pain Tolerable?:'
    ..getRangeByIndex(7, c5).text = exercise.tolerable
    ..autoFitColumn(c4)
    ..autoFitColumn(c5);

  if (exercise.mvcValue == null && prescription != null) {
    sheet
      ..getRangeByIndex(9, c4).text = 'Exercise Info'
      ..getRangeByIndex(10, c4).text = 'Target Load [Kg]'
      ..getRangeByIndex(10, c5).number = prescription.targetLoad
      ..getRangeByIndex(11, c4).text = 'Hold Time [Sec]'
      ..getRangeByIndex(11, c5).number = prescription.holdTime.toDouble()
      ..getRangeByIndex(12, c4).text = 'Rest Time [Sec]'
      ..getRangeByIndex(12, c5).number = prescription.restTime.toDouble()
      ..getRangeByIndex(13, c4).text = 'Sets [#]'
      ..getRangeByIndex(13, c5).number = prescription.sets.toDouble()
      ..getRangeByIndex(14, c4).text = 'Reps [#]'
      ..getRangeByIndex(14, c5).number = prescription.reps.toDouble();
  }

  for (var (index, data) in exercise.data.indexed) {
    sheet
      ..getRangeByIndex(index + 1, 1).number = data.time
      ..getRangeByIndex(index + 1, 2).number = data.load;
  }

  final file = ArchiveFile.bytes(
    '${exercise.datetime}-${exercise.userId}.zip',
    book.saveAsStream(),
  );

  book.dispose();

  return file;
}
