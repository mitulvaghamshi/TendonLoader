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
      'id': int id,
      'reps': int reps,
      'sets': int sets,
      'set_rest': int setRest,
      'hold_time': int holdTime,
      'rest_time': int restTime,
      'mvc_duration': int mvcDuration,
      'target_load': num targetLoad,
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
    throw FormatException('[Prescription]: Invalid JSON data: $json');
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

extension Utils on Prescription {
  List<TableItem> get tableRows => [
    (label: 'Target load', value: '$targetLoad Kg'),
    (label: 'Sets #', value: '$sets'),
    (label: 'Reps #', value: '$reps'),
    (label: 'Hold time', value: '$holdTime Sec'),
    (label: 'Rest time', value: '$restTime Sec'),
    (label: 'Set rest time', value: '$setRest Sec'),
  ];

  Map<String, dynamic> get map => {
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

typedef TableItem = ({String label, String value});
