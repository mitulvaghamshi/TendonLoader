import 'package:flutter/foundation.dart';

@immutable
class Prescription {
  const Prescription._({
    required this.id,
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
      sets = 0,
      reps = 0,
      setRest = 0,
      holdTime = 0,
      restTime = 0,
      mvcDuration = 0,
      targetLoad = 0;

  factory Prescription.fromJson(Map<String, dynamic> map) =>
      ExPrescription._parseJson(map);

  final int? id;
  final int sets;
  final int reps;
  final int setRest;
  final int holdTime;
  final int restTime;
  final int mvcDuration;
  final double targetLoad;
}

extension ExPrescription on Prescription {
  List<(String, String)> get tableRows => [
    ('Target load', '$targetLoad Kg'),
    ('Sets #', '$sets'),
    ('Reps #', '$reps'),
    ('Hold time', '$holdTime Sec'),
    ('Rest time', '$restTime Sec'),
    ('Set rest time', '$setRest Sec'),
  ];

  Map<String, dynamic> get json => {
    'id': id,
    'reps': reps,
    'sets': sets,
    'set_rest': setRest,
    'hold_time': holdTime,
    'rest_time': restTime,
    'mvc_duration': mvcDuration,
    'target_load': targetLoad,
  };

  Prescription copyWith({
    int? id,
    int? sets,
    int? reps,
    int? setRest,
    int? holdTime,
    int? restTime,
    int? mvcDuration,
    double? targetLoad,
  }) {
    return Prescription._(
      id: id ?? this.id,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      setRest: setRest ?? this.setRest,
      holdTime: holdTime ?? this.holdTime,
      restTime: restTime ?? this.restTime,
      mvcDuration: mvcDuration ?? this.mvcDuration,
      targetLoad: targetLoad ?? this.targetLoad,
    );
  }

  static Prescription _parseJson(Map<String, dynamic> map) {
    if (map case {
      'id': int id,
      'reps': int reps,
      'sets': int sets,
      'set_rest': int setRest,
      'hold_time': int holdTime,
      'rest_time': int restTime,
      'mvc_duration': int mvcDuration,
      'target_load': num targetLoad,
    }) {
      return Prescription._(
        id: id,
        sets: sets,
        reps: reps,
        setRest: setRest,
        holdTime: holdTime,
        restTime: restTime,
        mvcDuration: mvcDuration,
        targetLoad: targetLoad.toDouble(),
      );
    }
    throw const FormatException('[Prescription]: Invalid JSON');
  }
}
