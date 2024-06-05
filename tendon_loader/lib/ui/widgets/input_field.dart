import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.padding,
    this.keyboardType,
    this.validateMode,
    this.formatters,
    this.validator,
    this.onComplete,
    required this.label,
    required this.controller,
  });

  const factory InputField.search({
    Key? key,
    required final String label,
    required final VoidCallback? onComplete,
    required final TextEditingController controller,
  }) = _SearchField;

  const factory InputField.form({
    final Key? key,
    final String? format,
    final EdgeInsetsGeometry? padding,
    final TextInputType? keyboardType,
    required final String label,
    required final TextEditingController controller,
  }) = _FormField;

  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final AutovalidateMode? validateMode;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final VoidCallback? onComplete;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Widget widget = TextFormField(
      style: Styles.titleStyle,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      autovalidateMode: validateMode,
      onEditingComplete: onComplete,
      decoration: InputDecoration(
        labelText: label,
        suffix: IconButton(
          onPressed: controller.clear,
          icon: const Icon(Icons.clear),
        ),
      ),
    );
    if (padding != null) {
      widget = Padding(padding: padding!, child: widget);
    }
    return widget;
  }
}

@immutable
class _SearchField extends InputField {
  const _SearchField({
    super.key,
    required super.label,
    required super.controller,
    required super.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return InputField(
      label: label,
      controller: controller,
      onComplete: onComplete,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

@immutable
class _FormField extends InputField {
  const _FormField({
    super.key,
    this.format,
    super.padding,
    super.keyboardType,
    required super.label,
    required super.controller,
  });

  final String? format;

  @override
  Widget build(BuildContext context) {
    return InputField(
      key: key,
      label: label,
      padding: padding,
      validateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.number,
      controller: controller,
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
      formatters: [
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format!))
      ],
    );
  }
}
