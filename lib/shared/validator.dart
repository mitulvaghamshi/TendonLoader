mixin ValidateCredentialMixin {
  String? validateName(String? name) => name!.isEmpty ? 'Name can\'t be empty!' : null;

  String? validateEmail(String? email) {
    final RegExp _emailEx = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email!.isEmpty)
      return 'Email can\'t be empty!';
    else if (!_emailEx.hasMatch(email)) return 'Enter a correct email address!';
    return null;
  }

  String? validatePassword(String? password) {
    if (password!.isEmpty)
      return 'Password can\'t be empty';
    else if (password.length < 6) return 'Password must be at least 6 characters long!';
    return null;
  }
}

mixin ValidateExerciseDataMixin {
  String? validateTargetLoad(String? targetLoad) {
    if (targetLoad!.isEmpty)
      return 'Target load can\'t be empty!';
    else if (int.parse(targetLoad) < 0) return 'Target load can\'t be negative!';
    return null;
  }

  String? validateHoldTime(String? holdTime) {
    if (holdTime!.isEmpty)
      return 'Hold time can\'t be empty!';
    else if (int.parse(holdTime) < 0) return 'Hold time can\'t be negative!';
    return null;
  }

  String? validateRestTime(String? restTime) {
    if (restTime!.isEmpty)
      return 'Rest time can\'t be empty!';
    else if (int.parse(restTime) < 0) return 'Rest time  cn\'t be negative!';
    return null;
  }

  String? validateSets(String? sets) {
    if (sets!.isEmpty)
      return '# of sets can\'t be empty!';
    else if (int.parse(sets) < 0) return '# of sets can\'t be negative!';
    return null;
  }

  String? validateReps(String? reps) {
    if (reps!.isEmpty)
      return '# of reps can\'t be empty!';
    else if (int.parse(reps) < 0) return '# of reps can\'t be negative!';
    return null;
  }
}

mixin ValidateSearchMixin {
  String? validateSearchQuery(String? query) => null;
}

/* uploadTask.addOnProgressListener { (bytesTransferred, totalByteCount) ->
  val progress = (100.0 * bytesTransferred) / totalByteCount
  Log.d(TAG, "Upload is $progress% done")
}.addOnPausedListener {
  Log.d(TAG, "Upload is paused")
} */
