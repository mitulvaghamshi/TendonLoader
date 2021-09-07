/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    this.hint,
    required this.onSearch,
    required this.controller,
  }) : super(key: key);

  final String? hint;
  final VoidCallback onSearch;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (_) => onSearch(),
      controller: controller,
      style: const TextStyle(color: colorPrimaryWhite),
      decoration: InputDecoration(
        filled: true,
        fillColor: colorAccentBlack,
        hintText: hint ?? 'Search here...',
        hintStyle: const TextStyle(color: colorPrimaryWhite),
        prefixIcon: IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search, color: colorPrimaryWhite),
        ),
        suffixIcon: IconButton(
          onPressed: controller.clear,
          icon: const Icon(Icons.clear, color: colorPrimaryWhite),
        ),
      ),
    );
  }
}
