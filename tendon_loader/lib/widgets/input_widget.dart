import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/common/constants.dart';

@immutable
final class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    this.keyboardType,
    this.validateMode,
    this.formatters,
    this.validator,
    this.onComplete,
    required this.label,
    required this.controller,
  });

  const factory InputWidget.search({
    Key? key,
    required final String label,
    required final VoidCallback? onComplete,
    required final TextEditingController controller,
  }) = SearchField;

  factory InputWidget.validated({
    final Key? key,
    final String? format,
    final TextInputType? keyboardType,
    required final String label,
    required final TextEditingController controller,
  }) {
    return InputWidget(
      key: key,
      label: label,
      validateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.number,
      controller: controller,
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
      formatters: [
        if (format != null) FilteringTextInputFormatter.allow(RegExp(format))
      ],
    );
  }

  final TextInputType? keyboardType;
  final AutovalidateMode? validateMode;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final VoidCallback? onComplete;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
  }
}

@immutable
final class SearchField extends InputWidget {
  const SearchField({
    super.key,
    required super.label,
    required super.controller,
    required super.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputWidget(
        label: label,
        controller: controller,
        onComplete: onComplete,
      ),
    );
  }
}
