/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:tendon_loader/utils/constants.dart';

/// A simple number validator for integers and floating point values,
/// it will check and warn user for empty field and negative values.
/// Further restrictions are applied to respective text fields using RegEx.
String? validateNum(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return '* required';
  } else if (double.tryParse(value)! < 0) {
    return 'Value cannot be negative!!!';
  }
}

/// Email validator for login and registration screens,
/// it will strictly match an email address with give RegEx pattern,
/// see [lib/utils/constants.dart] for the RegEx pattern used.
String? validateEmail(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Email can\'t be empty.';
  } else if (!RegExp(emailRegEx).hasMatch(value)) {
    return 'Enter a correct email address.';
  }
}

/// The password validator uses simple rule of no-empty and 
/// have to have at least 6 character long password. 
/// Both the email and passwords are further validated by Firebase,
/// during login or registration proccess.
String? validatePass(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Password can\'t be empty.';
  } else if (value.length < 6) {
    return 'Password must be at least 6 characters long.';
  }
}
