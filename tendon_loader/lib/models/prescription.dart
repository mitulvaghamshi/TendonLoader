import 'package:flutter/foundation.dart';

@immutable
final class Prescription {
  const Prescription._({
    required this.id,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.setRest,
    required this.holdTime,
    required this.restTime,
    required this.mvcDuration,
    required this.targetLoad,
  });

  const Prescription.empty()
      : id = null,
        exerciseId = null,
        sets = 0,
        reps = 0,
        setRest = 0,
        holdTime = 0,
        restTime = 0,
        mvcDuration = 0,
        targetLoad = 0;

  factory Prescription.fromJson(final map) => ExPrescription._parseJson(map);

  final int? id;
  final int? exerciseId;
  final int sets;
  final int reps;
  final int setRest;
  final int holdTime;
  final int restTime;
  final int mvcDuration;
  final double targetLoad;
}

extension ExPrescription on Prescription {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'set_rest': setRest,
      'hold_time': holdTime,
      'rest_time': restTime,
      'mvc_duration': mvcDuration,
      'target_load': targetLoad,
    };
  }

  Prescription copyWith({
    final int? id,
    final int? exerciseId,
    final int? sets,
    final int? reps,
    final int? setRest,
    final int? holdTime,
    final int? restTime,
    final int? mvcDuration,
    final double? targetLoad,
  }) {
    return Prescription._(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      setRest: setRest ?? this.setRest,
      holdTime: holdTime ?? this.holdTime,
      restTime: restTime ?? this.restTime,
      mvcDuration: mvcDuration ?? this.mvcDuration,
      targetLoad: targetLoad ?? this.targetLoad,
    );
  }

  static Prescription _parseJson(final map) {
    if (map
        case {
          'id': final int id,
          'exercise_id': final int exerciseId,
          'sets': final int sets,
          'reps': final int reps,
          'set_rest': final int setRest,
          'hold_time': final int holdTime,
          'rest_time': final int restTime,
          'mvc_duration': final int mvcDuration,
          'target_load': final double targetLoad,
        }) {
      return Prescription._(
        id: id,
        exerciseId: exerciseId,
        sets: sets,
        reps: reps,
        setRest: setRest,
        holdTime: holdTime,
        restTime: restTime,
        mvcDuration: mvcDuration,
        targetLoad: targetLoad,
      );
    }
    throw const FormatException('Invalid JSON');
  }
}
