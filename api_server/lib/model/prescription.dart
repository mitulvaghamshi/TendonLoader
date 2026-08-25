import 'package:api_server/sql/prescription_table.dart';

class const Prescription._({
  required final int? id,
  required final int sets,
  required final int reps,
  required final int setRest,
  required final int holdTime,
  required final int restTime,
  required final int mvcDuration,
  required final double targetLoad,
}) {
  factory empty() => const ._(
    id: null,
    sets: 0,
    reps: 0,
    setRest: 0,
    holdTime: 0,
    restTime: 0,
    mvcDuration: 0,
    targetLoad: 0,
  );

  factory fromJson(Object? json) {
    if (json case {
      PrescriptionTable.kId: final int id,
      PrescriptionTable.kReps: final int reps,
      PrescriptionTable.kSets: final int sets,
      PrescriptionTable.kSetRest: final int setRest,
      PrescriptionTable.kHoldTime: final int holdTime,
      PrescriptionTable.kRestTime: final int restTime,
      PrescriptionTable.kMvcDuration: final int mvcDuration,
      PrescriptionTable.kTargetLoad: final num targetLoad,
    }) {
      return ._(
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
    throw Exception('[$Prescription]: ${StackTrace.current}');
  }
}

extension PrescriptionExt on Prescription {
  Iterable<({String label, String value})> get tableRows => [
    (label: 'Target load', value: '$targetLoad Kg'),
    (label: 'Sets #', value: '$sets'),
    (label: 'Reps #', value: '$reps'),
    (label: 'Hold time', value: '$holdTime Sec'),
    (label: 'Rest time', value: '$restTime Sec'),
    (label: 'Set rest time', value: '$setRest Sec'),
  ];

  Map<String, dynamic> get map => {
    PrescriptionTable.kId: id,
    PrescriptionTable.kReps: reps,
    PrescriptionTable.kSets: sets,
    PrescriptionTable.kSetRest: setRest,
    PrescriptionTable.kHoldTime: holdTime,
    PrescriptionTable.kRestTime: restTime,
    PrescriptionTable.kMvcDuration: mvcDuration,
    PrescriptionTable.kTargetLoad: targetLoad,
  };

  Prescription copyWith({
    int? sets,
    int? reps,
    int? setRest,
    int? holdTime,
    int? restTime,
    int? mvcDuration,
    double? targetLoad,
  }) => ._(
    id: id,
    sets: sets ?? this.sets,
    reps: reps ?? this.reps,
    setRest: setRest ?? this.setRest,
    holdTime: holdTime ?? this.holdTime,
    restTime: restTime ?? this.restTime,
    mvcDuration: mvcDuration ?? this.mvcDuration,
    targetLoad: targetLoad ?? this.targetLoad,
  );
}
