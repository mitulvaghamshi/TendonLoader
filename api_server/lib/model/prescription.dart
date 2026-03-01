import 'package:api_server/sql/prescription_table.dart';

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

  factory Prescription.fromJson(Object? json) {
    if (json case {
      PrescriptionTable.kId: int id,
      PrescriptionTable.kReps: int reps,
      PrescriptionTable.kSets: int sets,
      PrescriptionTable.kSetRest: int setRest,
      PrescriptionTable.kHoldTime: int holdTime,
      PrescriptionTable.kRestTime: int restTime,
      PrescriptionTable.kMvcDuration: int mvcDuration,
      PrescriptionTable.kTargetLoad: num targetLoad,
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

    throw FormatException('[$Prescription]: Invalid JSON data: $json');
  }

  final int? id;
  final int sets;
  final int reps;
  final int setRest;
  final int holdTime;
  final int restTime;
  final int mvcDuration;
  final double targetLoad;
}

extension PrescriptionExt on Prescription {
  List<({String label, String value})> get tableRows => [
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
