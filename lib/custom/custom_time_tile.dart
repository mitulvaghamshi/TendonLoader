import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_picker.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomTimeTile extends StatelessWidget {
  const CustomTimeTile({
    Key? key,
    required this.time,
    required this.desc,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final int time;
  final String desc;
  final String title;
  final ValueChanged<int> onChanged;

  String get _timeString {
    final Duration _time = Duration(seconds: time);
    return '${_time.inMinutes} Min : ${_time.inSeconds % 60} Sec';
  }

  Future<int?> _selectTime(BuildContext context) {
    int _min = 0;
    int _sec = 0;

    return CustomDialog.show<int?>(
      context,
      title: title,
      action: CustomButton(
        right: const Text('Ok'),
        left: const Icon(Icons.done),
        onPressed: () => context.pop<int>(
          Duration(minutes: _min, seconds: _sec).inSeconds,
        ),
      ),
      content: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomPicker(label: 'Min', onChanged: (int val) => _min = val),
            CustomPicker(label: 'Sec', onChanged: (int val) => _sec = val),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: UnderlineInputBorder(
        borderSide: BorderSide(
          color: time > 0 ? colorGoogleGreen : colorRed400,
        ),
      ),
      subtitle: Text(desc),
      contentPadding: EdgeInsets.zero,
      title: Text(_timeString, style: ts18w5),
      trailing: IconButton(
        icon: const Icon(Icons.timer, color: colorBlue),
        onPressed: () async {
          final int? duration = await _selectTime(context);
          if (duration != null) onChanged(duration);
        },
      ),
    );
  }
}
