 
import 'package:tendon_loader/constants/others.dart';

String? validateEmail(String? email) {
  if (email != null) {
    if (email.isEmpty) {
      return 'Email can\'t be empty.';
    } else if (!RegExp(regexEmail).hasMatch(email)) {
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
