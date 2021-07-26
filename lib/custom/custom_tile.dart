import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/textstyles.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({Key? key, this.icon, this.color, this.onTap, this.endIcon, required this.name}) : super(key: key);

  final String name;
  final Color? color;
  final Icon? endIcon;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      trailing: endIcon,
      title: Text(name, style: ts18BFF),
      contentPadding: const EdgeInsets.all(16),
      leading: CustomButton(icon: Icon(icon, size: 30), color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
