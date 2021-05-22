mixin ValidateCredentialMixin {
  String? validateName(String? name) => name != null && name.isEmpty ? 'Name can\'t be empty.' : null;

  String? validateEmail(String? email) {
    if (email != null) {
      final RegExp _emailEx = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      if (email.isEmpty) {
        return 'Email can\'t be empty.';
      } else if (!_emailEx.hasMatch(email)) {
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
}

mixin ValidateExerciseDataMixin {
  String? validateTargetLoad(String? targetLoad) {
    if (targetLoad != null) {
      if (targetLoad.isEmpty) {
        return '* required';
      } else if (double.tryParse(targetLoad)! <= 0) {
        return 'Must be greater then zero.';
      }
    }
    return null;
  }

  String? validateHoldTime(String? holdTime) {
    if (holdTime != null) {
      if (holdTime.isEmpty) {
        return '* required';
      } else if (int.tryParse(holdTime)! < 0) {
        return 'Hold time can\'t be negative.';
      }
    }
    return null;
  }

  String? validateRestTime(String? restTime) {
    if (restTime != null) {
      if (restTime.isEmpty) {
        return '* required';
      } else if (int.tryParse(restTime)! < 0) {
        return 'Rest time can\'t be negative.';
      }
    }
    return null;
  }

  String? validateSets(String? sets) {
    if (sets != null) {
      if (sets.isEmpty) {
        return '* required';
      } else if (int.tryParse(sets)! <= 0) {
        return 'Must be greater then zero.';
      }
    }
    return null;
  }

  String? validateReps(String? reps) {
    if (reps != null) {
      if (reps.isEmpty) {
        return '* required';
      } else if (int.tryParse(reps)! <= 0) {
        return 'Must be greater then zero.';
      }
    }
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
