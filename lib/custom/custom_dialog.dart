import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, required this.title, this.action, this.content}) : super(key: key);

  final String title;
  final Widget? action;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: content,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        FittedBox(child: Text(title, style: ts20B)),
        const SizedBox(width: 5),
        FittedBox(child: action ?? CustomButton(onPressed: context.pop, left: const Icon(Icons.clear))),
      ]),
    );
  }
}
