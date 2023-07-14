import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/common/constants.dart';

@immutable
final class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    this.label,
    this.format,
    this.controller,
    this.keyboardType,
  });

  final String? label;
  final String? format;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Styles.titleStyle,
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format!)),
      ],
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        suffix: IconButton(
          onPressed: controller!.clear,
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }
}
