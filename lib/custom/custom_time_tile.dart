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
        title: 'Select Time (min:sec)',
        action: CustomButton(
          radius: 25,
          left: const Icon(Icons.done_rounded, color: colorGoogleGreen),
          onPressed: () => context.pop<Duration>(Duration(minutes: _min, seconds: _sec)),
        ),
        content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          CustomPicker(value: 0, onChanged: (int val) => _min = val),
          const Text(':', style: ts22BFF),
          CustomPicker(value: 0, onChanged: (int val) => _sec = val),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(desc),
      contentPadding: EdgeInsets.zero,
      title: Text(_timeString, style: time.inSeconds > 0 ? tsG18B : tsR18B),
      trailing: IconButton(
        icon: const Icon(Icons.timer),
        onPressed: () async {
          final Duration? duration = await _selectTime(context);
          if (duration != null) onChanged(duration);
        },
      ),
    );
  }
}
