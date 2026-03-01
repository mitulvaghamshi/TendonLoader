import 'package:api_server/api_server.dart';
import 'package:api_server/sql/exercise_table.dart';

class ExerciseData {
  const ExerciseData({required this.exercises});

  factory ExerciseData.fromJson(Object? json) {
    if (json case {'exercises': List<dynamic> items}) {
      return .new(exercises: items.map(Exercise.fromJson));
    }

    throw FormatException('[$ExerciseData]: Invalid JSON data: $json');
  }

  final Iterable<Exercise> exercises;
}

class Exercise {
  const Exercise._({
    required this.id,
    required this.userId,
    required this.painScore,
    required this.datetime,
    required this.tolerable,
    required this.completed,
    required this.progressorId,
    required this.prescriptionId,
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
      prescriptionId = null,
      mvcValue = 0,
      data = const [];

  factory Exercise.fromJson(Object? json) {
    if (json case {
      ExerciseTable.kId: int id,
      ExerciseTable.kUserId: int userId,
      ExerciseTable.kPrescriptionId: int? prescriptionId,
      ExerciseTable.kPainScore: num painScore,
      ExerciseTable.kDatetime: String datetime,
      ExerciseTable.kTolerable: String tolerable,
      ExerciseTable.kCompleted: bool completed,
      ExerciseTable.kProgressorId: String progressorId,
      ExerciseTable.kMvcValue: double? mvcValue,
      ExerciseTable.kData: String rawData,
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

    throw FormatException('[$Exercise]: Invalid JSON data: $json');
  }

  final int id;
  final int userId;
  final double painScore;
  final String datetime;
  final String tolerable;
  final bool completed;
  final String progressorId;
  final int? prescriptionId;
  final double? mvcValue;
  final Iterable<ChartData> data;
}

extension ExerciseExt on Exercise {
  bool get isMVC => mvcValue != null && prescriptionId == null;
  String get type => isMVC ? 'MVC Test' : 'Exercise';
  String get status => completed ? 'Complete' : 'Incomplete';

  List<({String label, String value})> get tableRows => [
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
