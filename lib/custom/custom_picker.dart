import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomPicker extends StatelessWidget {
  const CustomPicker({Key? key, required this.label, required this.onChanged}) : super(key: key);

  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 150,
      child: Stack(alignment: Alignment.centerRight, children: <Widget>[
        CustomButton(
          right: Text(label, style: ts20B),
          left: const SizedBox(width: 45, height: 30),
        ),
        ListWheelScrollView(
          itemExtent: 30,
          diameterRatio: 1,
          magnification: 2,
          useMagnifier: true,
          onSelectedItemChanged: onChanged,
          physics: const FixedExtentScrollPhysics(),
          children: List<Widget>.generate(61, (int index) {
            return Container(
              width: 35,
              alignment: Alignment.centerLeft,
              child: Text(index.toString(), style: ts18B),
            );
          }),
        ),
      ]),
    );
  }
}
