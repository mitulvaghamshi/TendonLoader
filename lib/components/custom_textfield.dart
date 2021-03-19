import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/components/custom_timepicker.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.desc = '',
    @required this.label,
    this.isPicker = false,
    this.isObscure = false,
    @required this.validator,
    @required this.controller,
    this.hint = 'Enter value',
    @required this.keyboardType,
  });

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
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 20, fontFamily: 'Georgia'),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        helperText: desc,
        contentPadding: EdgeInsets.zero,
        hintStyle: const TextStyle(color: Colors.black54),
        labelStyle: const TextStyle(color: Colors.black87),
        helperStyle: const TextStyle(color: Colors.black54),
        errorStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        border: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.blue)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 3, color: Colors.redAccent)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.red)),
        suffix: IconButton(
          icon: Icon(isPicker ? Icons.timer : Icons.clear_rounded),
          onPressed: () async => isPicker ? controller.text = await TimePicker.selectTime(context) : controller.clear(),
        ),
      ),
    );
  }
}

/* suffixIcon: pPrefIcon == Icons.person
      ? IconButton(
    onPressed: () => setState(() => _mUserCtlr.clear()),
    icon: Icon(Icons.clear, color: Theme.of(context).accentColor),
  )
      : IconButton(
    color: Theme.of(context).accentColor,
    onPressed: () => setState(() => _mObscure = !_mObscure),
    icon: Icon(_mObscure ? Icons.visibility_off : Icons.visibility),
  ),*/
