import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomPicker extends StatelessWidget {
  const CustomPicker({Key? key, required this.value, required this.onChanged}) : super(key: key);

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 100,
      child: Stack(alignment: Alignment.center, children: <Widget>[
        const CustomButton(),
        ListWheelScrollView(
          itemExtent: 40,
          useMagnifier: true,
          magnification: 1.5,
          onSelectedItemChanged: onChanged,
          physics: const FixedExtentScrollPhysics(),
          children: List<Widget>.generate(61, (int index) {
            return Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(index.toString(), style: ts18BFF),
            );
          }),
        ),
      ]),
    );
  }
}
