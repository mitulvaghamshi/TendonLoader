/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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
