import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_timepicker.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key key,
    this.desc = '',
    @required this.hint,
    @required this.label,
    this.isPicker = false,
    this.isObscure = false,
    @required this.validator,
    @required this.controller,
    @required this.keyboardType,
  }) : super(key: key);

  final String hint;
  final String desc;
  final String label;
  final bool isPicker;
  final bool isObscure;
  final TextInputType keyboardType;
  final Function(String) validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isPicker,
      validator: validator,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 20, fontFamily: 'Georgia'),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        labelText: label,
        helperText: desc,
        focusedBorder: _customBorder(color: Colors.blue),
        enabledBorder: _customBorder(color: Colors.black),
        errorBorder: _customBorder(color: Colors.redAccent),
        focusedErrorBorder: _customBorder(color: Colors.red),
        helperStyle: const TextStyle(color: Colors.lightBlue),
        errorStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        suffix: IconButton(
          icon: Icon(isPicker ? Icons.access_time_rounded : Icons.clear_rounded),
          onPressed: () async => isPicker ? controller.text = await TimePicker.selectTime(context) : controller.clear(),
        ),
      ),
    );
  }
}

OutlineInputBorder _customBorder({double radius = 30, double width = 2, @required Color color}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(width: width, color: color),
  );
}
