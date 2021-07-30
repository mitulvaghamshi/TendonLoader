import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_picker.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomTimeTile extends StatelessWidget {
  const CustomTimeTile({
    Key? key,
    required this.desc,
    required this.time,
    required this.onChanged,
  }) : super(key: key);

  final String desc;
  final Duration time;
  final ValueChanged<Duration> onChanged;

  String get _timeString => '${time.inMinutes} Min : ${time.inSeconds % 60} Sec';

  Future<Duration?> _selectTime(BuildContext context) {
    int _min = 0;
    int _sec = 0;
    return showDialog<Duration?>(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Select Time',
        action: CustomButton(
          right: const Text('Ok'),
          left: const Icon(Icons.done),
          onPressed: () => context.pop<Duration>(Duration(minutes: _min, seconds: _sec)),
        ),
        content: FittedBox(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
            CustomPicker(label: 'Min', onChanged: (int val) => _min = val),
            CustomPicker(label: 'Sec', onChanged: (int val) => _sec = val),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(desc),
      contentPadding: EdgeInsets.zero,
      title: Text(_timeString, style: time.inSeconds > 0 ? tsG20B : tsR20B),
      trailing: IconButton(
        icon: const Icon(Icons.timer, color: colorBlue),
        onPressed: () async {
          final Duration? duration = await _selectTime(context);
          if (duration != null) onChanged(duration);
        },
      ),
    );
  }
}
