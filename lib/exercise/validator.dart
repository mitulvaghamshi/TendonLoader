String? validateTargetLoad(String? targetLoad) {
  if (targetLoad == null) return null;
  if (targetLoad.isEmpty) {
    return '* required';
  } else if (double.tryParse(targetLoad)! <= 0) {
    return 'Must be greater then zero.';
  }
}

String? validateHoldTime(String? holdTime) {
  if (holdTime == null) return null;
  if (holdTime.isEmpty) {
    return '* required';
  } else if (int.tryParse(holdTime)! < 0) {
    return 'Hold time can\'t be negative.';
  }
}

String? validateRestTime(String? restTime) {
  if (restTime == null) return null;
  if (restTime.isEmpty) {
    return '* required';
  } else if (int.tryParse(restTime)! < 0) {
    return 'Rest time can\'t be negative.';
  }
}

String? validateSets(String? sets) {
  if (sets == null) return null;
  if (sets.isEmpty) {
    return '* required';
  } else if (int.tryParse(sets)! <= 0) {
    return 'Must be greater then zero.';
  }
}

String? validateReps(String? reps) {
  if (reps == null) return null;
  if (reps.isEmpty) {
    return '* required';
  } else if (int.tryParse(reps)! <= 0) {
    return 'Must be greater then zero.';
  }
}
