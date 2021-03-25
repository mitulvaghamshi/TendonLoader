// TODO(mitulvaghamshi): create and update validation rules

mixin ValidateCredentialMixin {
  String validateName(String name) => name.isEmpty ? 'Name can\'t be empty' : null;

  String validateEmail(String email) {
    final RegExp _emailEx = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty)
      return 'Email can\'t be empty';
    else if (!_emailEx.hasMatch(email)) return 'Enter a correct email';

    return null;
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }
    return null;
  }
}

mixin ValidateExerciseDataMixin {
  String validateTargetLoad(String value) => 'always error';

  String validateHoldTime(String value) => null;

  String validateRestTime(String value) => null;

  String validateSets(String value) => null;

  String validateReps(String value) => null;
}

/*
*  uploadTask.addOnProgressListener { (bytesTransferred, totalByteCount) ->
            val progress = (100.0 * bytesTransferred) / totalByteCount
            Log.d(TAG, "Upload is $progress% done")
        }.addOnPausedListener {
            Log.d(TAG, "Upload is paused")
        }
* */
