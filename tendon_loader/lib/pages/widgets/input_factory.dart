import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/constants.dart' show Styles;

@immutable
class InputFactory extends StatelessWidget {
  const InputFactory({
    required this.label,
    required this.controller,
    super.key,
    this.padding,
    this.keyboardType,
    this.validateMode,
    this.formatters,
    this.validator,
    this.onComplete,
  });

  const factory InputFactory.search({
    required String label,
    required VoidCallback? onComplete,
    required TextEditingController controller,
    Key? key,
  }) = _SearchField;

  const factory InputFactory.form({
    required String label,
    required TextEditingController controller,
    Key? key,
    String? format,
    EdgeInsetsGeometry? padding,
    TextInputType? keyboardType,
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
  Widget build(BuildContext context) => Padding(
    padding: padding ?? .zero,
    child: TextFormField(
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
    ),
  );
}

@immutable
class _SearchField extends InputFactory {
  const _SearchField({
    required super.label,
    required super.controller,
    required super.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InputFactory(
    label: label,
    controller: controller,
    onComplete: onComplete,
    padding: const .symmetric(horizontal: 16),
  );
}

@immutable
class _FormField extends InputFactory {
  const _FormField({
    required super.label,
    required super.controller,
    super.key,
    super.padding,
    super.keyboardType,
    this.format,
  });

  final String? format;

  @override
  Widget build(BuildContext context) => InputFactory(
    key: key,
    label: label,
    padding: padding,
    controller: controller,
    validateMode: .onUserInteraction,
    keyboardType: keyboardType ?? .number,
    validator: (value) =>
        value == null || value.isEmpty ? '$label is required' : null,
    formatters: [
      if (format != null) FilteringTextInputFormatter.allow(RegExp(format!)),
    ],
  );
}
