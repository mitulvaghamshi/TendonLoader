import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/components/custom_timepicker.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({this.hint = 'Enter value', this.helper = '', this.isPicker = false, this.controller});

  final String hint;
  final String helper;
  final bool isPicker;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isPicker,
      controller: controller,
      style: const TextStyle(fontSize: 20, fontFamily: 'Georgia'),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value.isEmpty ? '* Required field' : null,
      keyboardType: TextInputType.numberWithOptions(decimal: hint.contains('kg')),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          hint.contains('target') ? RegExp(r'^(\d{1,5})$') : RegExp(r'^(\d{1,2}([\.]?[\d]?)?)'),
        ),
      ],
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        helperText: helper,
        helperStyle: TextStyle(color: Colors.blue),
        suffix: IconButton(
          icon: Icon(isPicker ? Icons.timer : Icons.clear_rounded),
          onPressed: () async => isPicker ? controller.text = await TimePicker.selectTime(context) : controller.clear(),
        ),
      ),
    );
  }
}
