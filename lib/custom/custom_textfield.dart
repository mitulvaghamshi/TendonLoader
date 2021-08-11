import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/themes.dart';

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

  String? _validateNum(String? value) {
    if (value == null) return null;
    if (value.isEmpty) {
      return '* required';
    } else if (double.tryParse(value)! < 0) {
      return 'Value cannot be negative!!!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: ts20B,
      controller: controller,
      obscureText: isObscure,
      onFieldSubmitted: (_) => TextInputAction.go,
      validator: validator ?? _validateNum,
      keyboardType: keyboardType ?? TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: <TextInputFormatter>[if (format != null) FilteringTextInputFormatter.allow(RegExp(format!))],
      decoration: InputDecoration(
        labelText: label,
        suffix: suffix ?? IconButton(onPressed: controller!.clear, icon: const Icon(Icons.clear)),
      ),
    );
  }
}
