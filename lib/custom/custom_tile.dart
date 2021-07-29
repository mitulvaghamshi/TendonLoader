import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({Key? key, this.onTap, this.right, required this.left, required this.title}) : super(key: key);

  final String title;
  final Widget left;
  final Icon? right;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      trailing: right,
      title: Text(title, style: ts20BFF),
      contentPadding: const EdgeInsets.all(10),
      leading: CustomButton(left: left, rounded: true),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
