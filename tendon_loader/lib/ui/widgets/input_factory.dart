import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/constants.dart' show Styles;

@immutable
class InputFactory extends StatelessWidget {
  const InputFactory({
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

  const factory InputFactory.search({
    Key? key,
    required final String label,
    required final VoidCallback? onComplete,
    required final TextEditingController controller,
  }) = _SearchField;

  const factory InputFactory.form({
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
    final widget = TextFormField(
      style: Styles.bold18,
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
    if (padding == null) return widget;
    return Padding(padding: padding!, child: widget);
  }
}

@immutable
class _SearchField extends InputFactory {
  const _SearchField({
    super.key,
    required super.label,
    required super.controller,
    required super.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return InputFactory(
      label: label,
      controller: controller,
      onComplete: onComplete,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

@immutable
class _FormField extends InputFactory {
  const _FormField({
    super.key,
    super.padding,
    super.keyboardType,
    this.format,
    required super.label,
    required super.controller,
  });

  final String? format;

  @override
  Widget build(BuildContext context) {
    return InputFactory(
      key: key,
      label: label,
      padding: padding,
      controller: controller,
      validateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.number,
      validator: (value) {
        return value == null || value.isEmpty ? '$label is required' : null;
      },
      formatters: [
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format!)),
      ],
    );
  }
}
