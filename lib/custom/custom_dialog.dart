import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, this.content, this.title, this.action}) : super(key: key);

  final String? title;
  final Widget? action;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: content,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: FittedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Text(title ?? 'Tendon Loader', style: ts20B),
          const SizedBox(width: 5),
          action ?? CustomButton(onPressed: context.pop, right: const Text('Close'), left: const Icon(Icons.clear)),
        ]),
      ),
    );
  }
}
