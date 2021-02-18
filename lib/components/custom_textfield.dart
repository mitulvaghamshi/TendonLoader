import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({this.hint, this.controller});

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        suffix: IconButton(
          icon: Icon(Icons.clear_rounded),
          onPressed: () => controller.clear(),
        ),
      ),
    );
  }
}
