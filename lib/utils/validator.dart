/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:tendon_loader/utils/constants.dart';

String? validateNum(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return '* required';
  } else if (double.tryParse(value)! < 0) {
    return 'Value cannot be negative!!!';
  }
}

String? validateEmail(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Email can\'t be empty.';
  } else if (!RegExp(emailRegEx).hasMatch(value)) {
    return 'Enter a correct email address.';
  }
}

String? validatePass(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Password can\'t be empty.';
  } else if (value.length < 6) {
    return 'Password must be at least 6 characters long.';
  }
}
