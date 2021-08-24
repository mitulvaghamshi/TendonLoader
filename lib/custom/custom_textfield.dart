import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
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
      style: ts20B,
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
              icon: const Icon(Icons.clear, color: colorRed400),
            ),
      ),
    );
  }
}
