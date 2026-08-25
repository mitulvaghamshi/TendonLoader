import 'package:api_server/api_server.dart';
import 'package:api_server/sql/exercise_table.dart';

class const ExerciseData({required final Iterable<Exercise> exercises}) {
  factory fromJson(Object? json) {
    if (json case {'exercises': final Iterable<dynamic> items}) {
      return .new(exercises: items.map(Exercise.fromJson));
    }
    throw Exception('[$ExerciseData]: ${StackTrace.current}');
  }
}

class const Exercise._({
  required final int id,
  required final int userId,
  required final double painScore,
  required final String datetime,
  required final String tolerable,
  required final bool completed,
  required final String progressorId,
  required final int? prescriptionId,
  required final double? mvcValue,
  required final Iterable<ChartData> data,
}) {
  factory empty() => const ._(
    id: 0,
    userId: 0,
    painScore: 0,
    datetime: '',
    tolerable: '',
    completed: false,
    progressorId: '',
    prescriptionId: null,
    mvcValue: 0,
    data: [],
  );

  factory fromJson(Object? json) {
    if (json case {
      ExerciseTable.kId: final int id,
      ExerciseTable.kUserId: final int userId,
      ExerciseTable.kPrescriptionId: final int? prescriptionId,
      ExerciseTable.kPainScore: final num painScore,
      ExerciseTable.kDatetime: final String datetime,
      ExerciseTable.kTolerable: final String tolerable,
      ExerciseTable.kCompleted: final bool completed,
      ExerciseTable.kProgressorId: final String progressorId,
      ExerciseTable.kMvcValue: final double? mvcValue,
      ExerciseTable.kData: final String rawData,
    }) {
      return ._(
        id: id,
        userId: userId,
        painScore: painScore.toDouble(),
        datetime: datetime,
        tolerable: tolerable,
        completed: completed,
        progressorId: progressorId,
        prescriptionId: prescriptionId,
        mvcValue: mvcValue,
        data: rawData.split('|').map(ChartData.fromPair),
      );
    }
    throw Exception('[$Exercise]: ${StackTrace.current}');
  }
}

extension ExerciseExt on Exercise {
  bool get isMVC => mvcValue != null && prescriptionId == null;
  String get type => isMVC ? 'MVC Test' : 'Exercise';
  String get status => completed ? 'Complete' : 'Incomplete';

  Iterable<({String label, String value})> get tableRows => [
    (label: 'User ID', value: userId.toString()),
    (label: 'Created on', value: datetime),
    (label: 'Session type', value: type),
    (label: 'Data status', value: status),
    (label: 'Device', value: progressorId),
    (label: 'Pain score', value: '$painScore / 10'),
    (label: 'Pain tolerable?', value: tolerable),
    if (isMVC)
      (label: 'Max force', value: '${mvcValue!.toStringAsFixed(2)} kg'),
  ];

  Map<String, dynamic> get map => {
    ExerciseTable.kId: id,
    ExerciseTable.kUserId: userId,
    ExerciseTable.kPrescriptionId: progressorId,
    ExerciseTable.kPainScore: painScore,
    ExerciseTable.kDatetime: datetime,
    ExerciseTable.kTolerable: tolerable,
    ExerciseTable.kCompleted: completed ? 1 : 0,
    ExerciseTable.kProgressorId: prescriptionId,
    ExerciseTable.kMvcValue: mvcValue,
    ExerciseTable.kData: data.map((e) => e.pair).join('|'),
  };

  Exercise copyWith({
    int? userId,
    double? painScore,
    String? datetime,
    String? tolerable,
    bool? completed,
    String? progressorId,
    int? prescriptionId,
    double? mvcValue,
    Iterable<ChartData>? data,
  }) => ._(
    id: id,
    userId: userId ?? this.userId,
    painScore: painScore ?? this.painScore,
    datetime: datetime ?? this.datetime,
    tolerable: tolerable ?? this.tolerable,
    completed: completed ?? this.completed,
    progressorId: progressorId ?? this.progressorId,
    prescriptionId: prescriptionId ?? this.prescriptionId,
    mvcValue: mvcValue ?? this.mvcValue,
    data: data ?? this.data,
  );
}
