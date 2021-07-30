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
      keyboardType: keyboardType ?? TextInputType.number,
      validator: validator ?? _validateNum,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: <TextInputFormatter>[if (format != null) FilteringTextInputFormatter.allow(RegExp(format!))],
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        errorStyle: const TextStyle(color: colorRed400),
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        suffix: suffix ?? IconButton(onPressed: controller!.clear, icon: const Icon(Icons.clear)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: colorRed400)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: colorGoogleGreen)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Theme.of(context).accentColor)),
      ),
    );
  }
}
