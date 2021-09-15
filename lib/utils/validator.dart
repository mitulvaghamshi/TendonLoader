/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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
