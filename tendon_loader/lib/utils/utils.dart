import 'dart:convert';
import 'dart:io';

import 'package:api_server/api_server.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/pages/widgets/anchor_element.dart';
import 'package:tendon_loader/utils/constants.dart';

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
  const c4 = 4;
  const c5 = 5;

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

  for (final (index, data) in exercise.data.indexed) {
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

Future<void> exportToJson(Exercise export) async {
  final map = export.map;
  final data = map.remove('"${TableKey.exportData}"') as String;

  final user = '${export.userId}-${export.datetime}'.replaceAll('@', '');

  if (!kIsWeb) {
    await (File('$user-user.json')..openWrite()).writeAsString(map.toString());
    await (File('$user-data.json')..openWrite()).writeAsString(data);
    return;
  }

  String encode(String value) =>
      'data:application/zip;base64,${utf8.fuse(base64).encode(value)}';

  AnchorElement(href: encode(map.toString()))
    ..setAttribute('download', '$user-user.json')
    ..click();

  AnchorElement(href: encode(data))
    ..setAttribute('download', '$user-data.json')
    ..click();
}

Future<void> exportToSql(Exercise export, Prescription? prescription) async {
  String dataString() => export.data.map((data) => data.pair).join('|');

  final exercise =
      'INSERT INTO Exercise '
      '("id", "user_id", "pain_score", "datetime", "tolerable", '
      '"completed", "progressor_id", "mvc_value", "data") '
      'VALUES (id, userId, painScore, format, isTolerable, '
      'isComplate ? 1 : 0, progressorId, mvcValue, "${dataString()}");';

  var prescriptionX = '';
  if (prescription != null) {
    prescriptionX = prescription.map.toString();
  }

  final user = '${export.userId}-${export.datetime}'.replaceAll('@', '');

  if (!kIsWeb) {
    await (File('$user-exercise.sql')..openWrite()).writeAsString(exercise);
    await (File(
      '$user-prescription.sql',
    )..openWrite()).writeAsString(prescriptionX);
    return;
  }

  String encode(String value) =>
      'data:application/zip;base64,${utf8.fuse(base64).encode(value)}';

  AnchorElement(href: encode(exercise))
    ..setAttribute('download', '$user-exercise-${export.id}.sql')
    ..click();

  AnchorElement(href: encode(prescriptionX))
    ..setAttribute('download', '$user-prescription-${prescription?.id}.sql')
    ..click();
}

final files = {
  'alexscott@tendonloader.com': [
    'alexscott@tendonloader.com-2023-05-03 00:26:33.668758.json',
  ],
  'kohlemerry@tendonloader.com': [
    'kohlemerry@tendonloader.com-2023-05-03 00:28:07.248471.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:13.917522.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:16.291933.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:19.844349.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:22.003248.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:32.229792.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:34.390883.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:36.053207.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:38.234111.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:40.274885.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:28:42.421533.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:29.229817.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:31.433512.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:34.909948.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:37.443025.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:39.735580.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:42.095710.json',
    'kohlemerry@tendonloader.com-2023-05-03 00:29:44.392022.json',
  ],
  'megan@tendonloader.com': [
    'megan@tendonloader.com-2023-05-03 00:30:11.552216.json',
    'megan@tendonloader.com-2023-05-03 00:30:14.258357.json',
    'megan@tendonloader.com-2023-05-03 00:30:16.033951.json',
    'megan@tendonloader.com-2023-05-03 00:30:17.540762.json',
    'megan@tendonloader.com-2023-05-03 00:30:19.139203.json',
    'megan@tendonloader.com-2023-05-03 00:30:21.127246.json',
    'megan@tendonloader.com-2023-05-03 00:30:23.203425.json',
  ],
  'mitul@gmail.com': [
    'mitul@gmail.com-2023-05-03 00:30:29.454625.json',
    'mitul@gmail.com-2023-05-03 00:30:31.316087.json',
    'mitul@gmail.com-2023-05-03 00:30:32.520078.json',
    'mitul@gmail.com-2023-05-03 00:30:34.334364.json',
    'mitul@gmail.com-2023-05-03 00:30:35.838861.json',
    'mitul@gmail.com-2023-05-03 00:30:37.640536.json',
    'mitul@gmail.com-2023-05-03 00:30:39.561037.json',
    'mitul@gmail.com-2023-05-03 00:30:40.834501.json',
    'mitul@gmail.com-2023-05-03 00:30:42.655610.json',
    'mitul@gmail.com-2023-05-03 00:30:44.298423.json',
  ],
};
