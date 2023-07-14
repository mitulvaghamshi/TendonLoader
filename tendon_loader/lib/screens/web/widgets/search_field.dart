import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.label,
    required this.onSearch,
    required this.controller,
  });

  final String label;
  final VoidCallback onSearch;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        style: Styles.titleStyle,
        controller: controller,
        onEditingComplete: onSearch,
        decoration: InputDecoration(
          label: Text(label, style: Styles.titleStyle),
          suffix: IconButton(
            onPressed: controller.clear,
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
