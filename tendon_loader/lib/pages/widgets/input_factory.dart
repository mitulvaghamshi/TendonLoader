import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/constants.dart' show Styles;

@immutable
class const InputFactory({
  required final String label,
  required final TextEditingController controller,
  super.key,
  final EdgeInsetsGeometry? padding,
  final TextInputType? keyboardType,
  final AutovalidateMode? validateMode,
  final List<TextInputFormatter>? formatters,
  final String? Function(String?)? validator,
  final VoidCallback? onComplete,
}) extends StatelessWidget {
  const factory search({
    required String label,
    required VoidCallback? onComplete,
    required TextEditingController controller,
    Key? key,
  }) = _SearchField;

  const factory form({
    required String label,
    required TextEditingController controller,
    Key? key,
    String? format,
    EdgeInsetsGeometry? padding,
    TextInputType? keyboardType,
  }) = _FormField;

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
class const _SearchField({
  required super.label,
  required super.controller,
  required super.onComplete,
  super.key,
}) extends InputFactory {
  @override
  Widget build(BuildContext context) => InputFactory(
    label: label,
    controller: controller,
    onComplete: onComplete,
    padding: const .symmetric(horizontal: 16),
  );
}

@immutable
class const _FormField({
  required super.label,
  required super.controller,
  super.key,
  super.padding,
  super.keyboardType,
  final String? format,
}) extends InputFactory {
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
