/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/time_picker.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class TimePickerTile extends StatelessWidget {
  const TimePickerTile({
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
            TimePicker(label: 'Min', onChanged: (int val) => _min = val),
            TimePicker(label: 'Sec', onChanged: (int val) => _sec = val),
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
          color: time > 0 ? colorMidGreen : colorErrorRed,
        ),
      ),
      subtitle: Text(desc),
      contentPadding: EdgeInsets.zero,
      title: Text(_timeString, style: ts18w5),
      trailing: IconButton(
        icon: const Icon(Icons.timer, color: colorIconBlue),
        onPressed: () async {
          final int? duration = await _selectTime(context);
          if (duration != null) onChanged(duration);
        },
      ),
    );
  }
}
