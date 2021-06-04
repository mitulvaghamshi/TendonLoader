import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({Key? key, this.icon, this.desc, this.title, this.onTap, this.padding}) : super(key: key);

  final Icon? icon;
  final String? desc;
  final String? title;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      subtitle: desc != null ? Text(desc!) : null,
      contentPadding: padding ?? const EdgeInsets.all(16),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
