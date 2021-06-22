import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/colors.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/time_picker.dart';

class CustomPicker extends StatefulWidget {
  const CustomPicker({Key? key, this.name, this.onChange}) : super(key: key);

  final String? name;
  final void Function(int)? onChange;

  @override
  _CustomPickerState createState() => _CustomPickerState();

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <CustomPicker>[
            CustomPicker(name: 'Min', onChange: (int value) => _min = value),
            CustomPicker(name: 'Sec', onChange: (int value) => _sec = value),
          ]),
          actions: <CustomButton>[
            CustomButton(
              color: colorGoogleGreen,
              text: const Text('Ok'),
              icon: const Icon(Icons.done_rounded),
              onPressed: () => Navigator.of(context).pop<String>(
                Duration(minutes: _min, seconds: _sec).inSeconds.toString(),
              ),
            ),
            CustomButton(
              text: const Text('Cancel'),
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop<void>(context),
            ),
          ],
        );
      },
    );
  }
}

class _CustomPickerState extends State<CustomPicker> {
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Text(widget.name!, style: const TextStyle(fontSize: 26)),
      TimePicker(
        value: _value,
        selectedTextStyle: const TextStyle(fontSize: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colorGoogleGreen),
        ),
        onChanged: (int value) {
          setState(() => widget.onChange!(_value = value));
        },
      ),
    ]);
  }
}
