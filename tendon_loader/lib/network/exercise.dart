import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/common/excel/save_excel.dart';
import 'package:tendon_loader/network/chartdata.dart';
import 'package:tendon_loader/network/prescription.dart';

@immutable
final class Exercise {
  const Exercise._({
    required this.id,
    required this.userId,
    required this.painScore,
    required this.datetime,
    required this.tolerable,
    required this.completed,
    required this.progressorId,
    required this.mvcValue,
    required this.data,
  });

  const Exercise.empty()
      : id = 0,
        userId = 0,
        painScore = 0,
        datetime = '',
        tolerable = '',
        completed = false,
        progressorId = '',
        mvcValue = 0,
        data = const [];

  factory Exercise.fromJson(final map) => ExExercise._parseJson(map);

  final int id;
  final int userId;
  final double painScore;
  final String datetime;
  final String tolerable;
  final bool completed;
  final String progressorId;
  final double? mvcValue;
  final Iterable<ChartData> data;
}

extension ExExercise on Exercise {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'pain_score': painScore,
      'datetime': datetime,
      'tolerable': tolerable,
      'completed': completed ? 1 : 0,
      'progressor_id': progressorId,
      'mvc_value': mvcValue,
      'data': data.map((e) => e.toPair()).join('|'),
    };
  }

  Exercise copyWith({
    final int? id,
    final int? userId,
    final double? painScore,
    final String? datetime,
    final String? tolerable,
    final bool? completed,
    final String? progressorId,
    final double? mvcValue,
    final Iterable<ChartData>? data,
  }) {
    return Exercise._(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      painScore: painScore ?? this.painScore,
      datetime: datetime ?? this.datetime,
      tolerable: tolerable ?? this.tolerable,
      completed: completed ?? this.completed,
      progressorId: progressorId ?? this.progressorId,
      mvcValue: mvcValue ?? this.mvcValue,
      data: data ?? this.data,
    );
  }

  static Exercise _parseJson(final map) {
    if (map
        case {
          'id': final int id,
          'user_id': final int userId,
          'pain_score': final double painScore,
          'datetime': final String datetime,
          'tolerable': final String tolerable,
          'completed': final int completedInt,
          'progressor_id': final String progressorId,
          'mvc_value': final double? mvcValue,
          'data': final String rawData,
        }) {
      final bool completed = completedInt == 1;
      final Iterable<ChartData> data =
          rawData.split('|').map(ChartData.fromPair);
      return Exercise._(
        id: id,
        userId: userId,
        painScore: painScore,
        datetime: datetime,
        tolerable: tolerable,
        completed: completed,
        progressorId: progressorId,
        mvcValue: mvcValue,
        data: data,
      );
    }
    throw const FormatException('Invalid JSON');
  }

  ArchiveFile _excelSheet([Prescription? prescription]) {
    final Workbook book = Workbook();
    final Worksheet sheet = book.worksheets[0];
    const int c4 = 4, c5 = 5;
    sheet
      ..getRangeByIndex(1, 1).setText('TIME [s]')
      ..getRangeByIndex(1, 2).setText('LOAD [Kg]')
      ..getRangeByIndex(1, c4).text = 'Date:'
      ..getRangeByIndex(1, c5).text = datetime
      ..getRangeByIndex(1, c5).numberFormat = 'yyyy-mmm-dd, dddd'
      ..getRangeByIndex(2, c4).text = 'Time:'
      ..getRangeByIndex(2, c5).text = datetime
      ..getRangeByIndex(2, c5).numberFormat = 'hh:mm:ss AM/PM'
      ..getRangeByIndex(3, c4).text = 'User ID:'
      ..getRangeByIndex(3, c5).text = userId.toString()
      ..getRangeByIndex(4, c4).text = 'Progressor ID:'
      ..getRangeByIndex(4, c5).text = progressorId
      ..getRangeByIndex(6, c4).text = 'Pain Score:'
      ..getRangeByIndex(6, c5).text = painScore.toString()
      ..getRangeByIndex(7, c4).text = 'Pain Tolerable?:'
      ..getRangeByIndex(7, c5).text = tolerable
      ..autoFitColumn(c4)
      ..autoFitColumn(c5);
    if (mvcValue == null && prescription != null) {
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

    for (final (int index, ChartData data) in data.indexed) {
      sheet
        ..getRangeByIndex(index, 1).number = data.time
        ..getRangeByIndex(index, 2).number = data.load;
    }

    final InputStream stream = InputStream(book.saveAsStream());
    final ArchiveFile file =
        ArchiveFile.stream('$datetime-$userId.zip', stream.length, stream);
    book.dispose();

    return file;
  }

  Future<bool> upload() async {
    try {
      if (userId == -1) throw 'Invalid patient id!';
      // TODO(me): Save to database...
      return true;
    } on Exception {
      return false;
    }
  }

  Future<void> download() async {
    await saveExcel(
      name: '$datetime-$userId.zip'.replaceAll(RegExp('[@:,]'), ''),
      bytes: ZipEncoder().encode(
        Archive()..addFile(_excelSheet(const Prescription.empty())),
      ),
    );
  }
}
