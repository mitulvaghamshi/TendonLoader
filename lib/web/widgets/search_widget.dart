import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
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
      controller: controller,
      onSubmitted: (_) => onSearch(),
      decoration: InputDecoration(
        filled: true,
        hintText: hint ?? 'Search here...',
        prefixIcon: IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search, color: Color(0xFF007AFF)),
        ),
        suffixIcon: IconButton(
          onPressed: controller.clear,
          icon: const Icon(Icons.clear, color: Color(0xFF007AFF)),
        ),
      ),
    );
  }
}
