import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      style: const TextStyle(fontSize: 20),
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
        suffix: IconButton(
          icon: Icon(isPicker ? Icons.timer : Icons.clear_rounded),
          onPressed: () async => isPicker ? await _selectTime(context) : controller.clear(),
        ),
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 00, minute: 00));
    if (picked != null) controller.text = '${picked.hour * 60 + picked.minute}';
  }
}
