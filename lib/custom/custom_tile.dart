import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    this.onTap,
    this.right,
    this.left,
    required this.title,
  }) : super(key: key);

  final String title;
  final Widget? left;
  final Icon? right;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: right,
      onTap: onTap ?? () {},
      title: Text(title, style: ts18w5),
      contentPadding: const EdgeInsets.all(16),
      leading: CustomButton(
        left: left,
        rounded: true,
        padding: EdgeInsets.zero,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
