import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/time_picker.dart';

class CustomPicker extends StatefulWidget {
  const CustomPicker({Key? key, this.name, this.onChange}) : super(key: key);

  final String? name;
  final void Function(int)? onChange;

  @override
  _CustomPickerState createState() => _CustomPickerState();

  static Future<String?> show(BuildContext context) {
    int _min = 0;
    int _sec = 0;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text(
            'Select Time (m:s)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: colorGoogleGreen, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(children: <Row>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <CustomPicker>[
              CustomPicker(onChange: (int value) => _min = value),
              CustomPicker(onChange: (int value) => _sec = value),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <CustomButton>[
              CustomButton(
                icon: const Icon(Icons.done_rounded, color: colorGoogleGreen),
                onPressed: () => Navigator.of(context).pop<String>(
                  Duration(minutes: _min, seconds: _sec).inSeconds.toString(),
                ),
              ),
              CustomButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop<void>(context),
              ),
            ])
          ]),
        );
      },
    );
  }
}

class _CustomPickerState extends State<CustomPicker> {
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    return TimePicker(
      value: _value,
      selectedTextStyle: const TextStyle(fontSize: 32, color: colorGoogleGreen),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2, color: Theme.of(context).accentColor),
      ),
      onChanged: (int value) {
        setState(() => widget.onChange!(_value = value));
      },
    );
  }
}
