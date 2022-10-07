import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    super.key,
    this.size,
    this.title,
    this.action,
    this.content,
  });

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
      builder: (_) => AlertWidget(
        size: size ?? const Size(350, 600),
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
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.only(left: 16),
      content: kIsWeb ? SizedBox.fromSize(size: size, child: content) : content,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FittedBox(
            child: Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 5),
          FittedBox(
            child: action ??
                ButtonWidget(
                  onPressed: context.pop,
                  left: const Icon(Icons.clear, color: Color(0xffff534d)),
                ),
          ),
        ],
      ),
    );
  }
}
