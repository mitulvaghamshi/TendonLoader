import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    this.color,
    this.endIcon,
    required this.name,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Color? color;
  final String name;
  final IconData icon;
  final Icon? endIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      trailing: endIcon,
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: CustomButton(icon: Icon(icon, size: 30), color: color, onPressed: () {}),
      title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
