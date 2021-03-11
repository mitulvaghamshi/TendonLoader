import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({this.text = 'Click', this.icon, this.color, this.onPressed});

  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ButtonStyle(
        visualDensity: VisualDensity(vertical: 1.5, horizontal: 2),
        backgroundColor: MaterialStateProperty.all<Color>(color??Colors.black),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
    );
  }
}
