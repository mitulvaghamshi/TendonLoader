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

String? validateTestDuration(String? duration) {
  if (duration == null) return null;
  if (duration.isEmpty) {
    return '* required';
  } else if (int.tryParse(duration)! < 0) {
    return 'Test duration can\'t be negative.';
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

const String _regexEmail =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String? validateEmail(String? email) {
  if (email != null) {
    if (email.isEmpty) {
      return 'Email can\'t be empty.';
    } else if (!RegExp(_regexEmail).hasMatch(email)) {
      return 'Enter a correct email address.';
    }
  }
  return null;
}

String? validatePassword(String? password) {
  if (password != null) {
    if (password.isEmpty) {
      return 'Password can\'t be empty.';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
  }
  return null;
}
