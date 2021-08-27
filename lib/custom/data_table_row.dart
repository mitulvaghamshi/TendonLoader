import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';

class DataTableRow extends StatelessWidget {
  const DataTableRow({
    Key? key,
    this.color,
    required this.left,
    required this.center,
    required this.right,
  }) : super(key: key);

  final Color? color;
  final Widget left;
  final Widget center;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      _buildItem(left),
      _buildItem(center),
      _buildItem(right),
    ]);
  }

  Expanded _buildItem(Widget child) {
    return Expanded(
      child: CustomButton(
        radius: 0,
        left: child,
        color: color,
        elevation: 3,
      ),
    );
  }
}
