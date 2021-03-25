import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tendon_loader/components/custom_button.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({Key key, this.name = 'Pick', this.onChange}) : super(key: key);

  final String name;
  final Function(int) onChange;

  @override
  TimePickerState createState() => TimePickerState();

  static Future<String> selectTime(BuildContext context) {
    int _min = 0;
    int _sec = 0;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <TimePicker>[
              TimePicker(name: 'MIN', onChange: (int value) => _min = value),
              TimePicker(name: 'SEC', onChange: (int value) => _sec = value),
            ],
          ),
          actions: <CustomButton>[
            CustomButton(
              text: 'Submit',
              color: Colors.blue,
              icon: Icons.done_rounded,
              onPressed: () => Navigator.pop<String>(context, Duration(minutes: _min, seconds: _sec).inSeconds.toString()),
            ),
            CustomButton(
              text: 'Cancel',
              color: Colors.grey,
              icon: Icons.cancel,
              onPressed: () => Navigator.pop<void>(context),
            ),
          ],
        );
      },
    );
  }
}

class TimePickerState extends State<TimePicker> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        NumberPicker(
          value: _value,
          minValue: 0,
          maxValue: 60,
          haptics: true,
          onChanged: (int value) => setState(() => widget.onChange(_value = value)),
          selectedTextStyle: const TextStyle(fontSize: 36, color: Colors.blue, fontWeight: FontWeight.bold),
          decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(100)),
        ),
      ],
    );
  }
}
