import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    this.size,
    this.title,
    this.action,
    this.content,
  }) : super(key: key);

  final Size? size;
  final String? title;
  final Widget? action;
  final Widget? content;

  static Future<T?> show<T>(
    BuildContext context, {
    Size? size,
    String? title,
    Widget? action,
    Widget? content,
  }) async {
    return showDialog<T?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        size: size ?? const Size(350, 700),
        title: title,
        action: action,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CustomButton _defaultAction = CustomButton(
      radius: 20,
      rounded: true,
      onPressed: context.pop,
      padding: EdgeInsets.zero,
      left: const Icon(Icons.clear, color: colorErrorRed),
    );
    if (kIsWeb) {
      return Center(
        child: AppFrame(
          padding: EdgeInsets.zero,
          child: SizedBox.fromSize(
            size: size,
            child: Scaffold(
              appBar: AppBar(
                leading: action,
                title: Text(title ?? 'Tendon Loader'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              body: Align(alignment: Alignment.topCenter, child: content),
            ),
          ),
        ),
      );
    }
    return AlertDialog(
      scrollable: true,
      content: content,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FittedBox(child: Text(title ?? '', style: ts18w5)),
          const SizedBox(width: 5),
          FittedBox(child: action ?? _defaultAction),
        ],
      ),
    );
  }
}
