mixin ValidateCredentialMixin {
  String validateName(String name) => name.isEmpty ? 'Name can\'t be empty' : null;

  String validateEmail(String email) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty)
      return 'Email can\'t be empty';
    else if (!emailRegExp.hasMatch(email)) return 'Enter a correct email';
    return null;
  }

  String validatePassword(String password) {
    if (password.isEmpty)
      return 'Password can\'t be empty';
    else if (password.length < 6) return 'Enter a password with length at least 6';
    return null;
  }
}

mixin ValidateExerciseDataMixin {
  String validateTargetLoad(String value) {
    return 'always error';
  }

  String validateHoldTime(String value) {}

  String validateRestTime(String value) {}

  String validateSets(String value) {}

  String validateReps(String value) {}
}
