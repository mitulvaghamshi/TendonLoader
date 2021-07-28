const String _regexEmail =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String? validateEmail(String? email) {
  if (email == null) return null;
  if (email.isEmpty) {
    return 'Email can\'t be empty.';
  } else if (!RegExp(_regexEmail).hasMatch(email)) {
    return 'Enter a correct email address.';
  }
}

String? validatePassword(String? password) {
  if (password == null) return null;
  if (password.isEmpty) {
    return 'Password can\'t be empty.';
  } else if (password.length < 6) {
    return 'Password must be at least 6 characters long.';
  }
}
