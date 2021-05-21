import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({Key? key, this.name, this.onChange}) : super(key: key);

  final String? name;
  final void Function(int)? onChange;

  @override
  _TimePickerState createState() => _TimePickerState();

  static Future<String?> selectTime(BuildContext context) {
    int _min = 0;
    int _sec = 0;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text(
            'Select Time',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontFamily: 'Georgia', fontWeight: FontWeight.w600),
          ),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <TimePicker>[
              TimePicker(name: 'Min', onChange: (int value) => _min = value),
              TimePicker(name: 'Sec', onChange: (int value) => _sec = value),
            ],
          ),
          actions: <CustomButton>[
            CustomButton(
              text: 'Submit',
              icon: Icons.done_rounded,
              background: Colors.green,
              onPressed: () => Navigator.of(context).pop<String>(
                Duration(minutes: _min, seconds: _sec).inSeconds.toString(),
              ),
            ),
            CustomButton(
              text: 'Cancel',
              icon: Icons.close_rounded,
              onPressed: () => Navigator.pop<void>(context),
            ),
          ],
        );
      },
    );
  }
}

class _TimePickerState extends State<TimePicker> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.name!,
          style: const TextStyle(
            fontSize: 26,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        NumberPicker(
          value: _value,
          minValue: 0,
          maxValue: 60,
          itemWidth: 80,
          haptics: true,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Theme.of(context).accentColor),
          ),
          onChanged: (int value) => setState(() => widget.onChange!(_value = value)),
          selectedTextStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
