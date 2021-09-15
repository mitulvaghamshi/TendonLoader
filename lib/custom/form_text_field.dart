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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    Key? key,
    this.label,
    this.suffix,
    this.format,
    this.validator,
    this.controller,
    this.keyboardType,
    this.isObscure = false,
  }) : super(key: key);

  final String? label;
  final String? format;
  final bool isObscure;
  final IconButton? suffix;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: ts18w5,
      controller: controller,
      obscureText: isObscure,
      validator: validator ?? validateNum,
      keyboardType: keyboardType ?? TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: <TextInputFormatter>[
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format!)),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffix: suffix ??
            IconButton(
              onPressed: controller!.clear,
              icon: const Icon(Icons.clear, color: colorErrorRed),
            ),
      ),
    );
  }
}
