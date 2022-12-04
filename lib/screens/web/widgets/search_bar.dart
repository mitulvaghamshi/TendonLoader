import 'package:flutter/cupertino.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  final VoidCallback onSearch;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CupertinoTextField(
        controller: controller,
        placeholder: 'Search...',
        onSubmitted: (String value) => onSearch(),
        prefix: const Icon(CupertinoIcons.search),
        clearButtonMode: OverlayVisibilityMode.editing,
      ),
    );
  }
}
