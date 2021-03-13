import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tendon_loader/components/custom_button.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({this.name = 'Pick', this.onChange});

  final Function(int) onChange;
  final String name;

  @override
  TimePickerState createState() => TimePickerState();

  static Future<String> selectTime(BuildContext context) async {
    int _min = 0;
    int _sec = 0;
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimePicker(name: 'Minutes', onChange: (value) => _min = value),
              TimePicker(name: 'Seconds', onChange: (value) => _sec = value),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Submit',
              color: Colors.blue,
              icon: Icons.done_rounded,
              onPressed: () {
                Navigator.pop<String>(context, Duration(minutes: _min, seconds: _sec).inSeconds.toString());
              },
            ),
            CustomButton(
              text: 'Cancel',
              color: Colors.grey,
              icon: Icons.cancel,
              onPressed: () => Navigator.pop<Null>(context),
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
      children: [
        Text(widget.name),
        NumberPicker(
          value: _value,
          minValue: 0,
          maxValue: 60,
          haptics: true,
          onChanged: (value) {
            setState(() => _value = value);
            widget.onChange(value);
          },
          selectedTextStyle: const TextStyle(
            fontSize: 36,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }
}
