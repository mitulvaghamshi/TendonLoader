import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    this.left,
    this.right,
    this.color,
    this.onPressed,
    this.size = MainAxisSize.min,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  final Color? color;
  final Widget? left;
  final Widget? right;
  final MainAxisSize size;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: padding,
      fillColor: color,
      onPressed: onPressed,
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      child: Row(
        mainAxisSize: size,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (left != null) left!,
          if (right != null) ...<Widget>[
            const SizedBox(width: 5),
            right!,
          ]
        ],
      ),
    );
  }
}
