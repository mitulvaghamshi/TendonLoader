import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.title,
    this.action,
    this.content,
  }) : super(key: key);

  final String title;
  final Widget? action;
  final Widget? content;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? action,
    Widget? content,
  }) async {
    return showDialog<T?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        title: title,
        action: action,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: content,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FittedBox(child: Text(title, style: ts20B)),
          const SizedBox(width: 5),
          FittedBox(
            child: action ??
                CustomButton(
                  radius: 20,
                  rounded: true,
                  onPressed: context.pop,
                  padding: EdgeInsets.zero,
                  left: const Icon(Icons.clear, color: colorRed400),
                ),
          ),
        ],
      ),
    );
  }
}
