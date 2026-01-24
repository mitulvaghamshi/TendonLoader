import 'package:server/models/chartdata.dart';

class ExerciseData {
  const ExerciseData({required this.exercises});

  factory ExerciseData.fromJson(Object? json) {
    if (json case {'exercises': List<dynamic> items}) {
      final exercises = List<Map<String, dynamic>>.from(items);
      return .new(exercises: exercises.map(Exercise.fromJson));
    }
    throw FormatException('[ExerciseData]: Invalid JSON data: $json');
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
      'id': int id,
      'user_id': int userId,
      'prescription_id': int? prescriptionId,
      'pain_score': num painScore,
      'datetime': String datetime,
      'tolerable': String tolerable,
      'completed': bool completed,
      'progressor_id': String progressorId,
      'mvc_value': double? mvcValue,
      'data': String rawData,
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
    throw FormatException('[Exercise]: Invalid JSON data: $json');
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

extension Utils on Exercise {
  bool get isMVC => mvcValue != null && prescriptionId == null;
  String get type => isMVC ? 'MVC Test' : 'Exercise';
  String get status => completed ? 'Complete' : 'Incomplete';

  List<TableItem> get tableRows => [
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
    'id': id,
    'user_id': userId,
    'prescription_id': progressorId,
    'pain_score': painScore,
    'datetime': datetime,
    'tolerable': tolerable,
    'completed': completed ? 1 : 0,
    'progressor_id': prescriptionId,
    'mvc_value': mvcValue,
    'data': data.map((e) => e.pair).join('|'),
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

typedef TableItem = ({String label, String value});
