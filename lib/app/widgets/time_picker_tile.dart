import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/alert_widget.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

class TimePickerTile extends StatelessWidget {
  const TimePickerTile({
    super.key,
    required this.time,
    required this.desc,
    required this.title,
    required this.onChanged,
  });

  final int time;
  final String desc;
  final String title;
  final ValueChanged<int> onChanged;

  String get _timeString {
    final Duration duration = Duration(seconds: time);
    return '${duration.inMinutes} Min : ${duration.inSeconds % 60} Sec';
  }

  Future<int?> _selectTime(BuildContext context) {
    int min = 0;
    int sec = 0;

    return AlertWidget.show<int?>(
      context,
      title: title,
      action: ButtonWidget(
        right: const Text('Ok'),
        left: const Icon(Icons.done, color: Color(0xFF007AFF)),
        onPressed: () => context.pop<int>(
          Duration(minutes: min, seconds: sec).inSeconds,
        ),
      ),
      content: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _NumberPicker(
              count: 60,
              label: 'Min',
              onChanged: (int val) => min = val,
            ),
            _NumberPicker(
              count: 60,
              label: 'Sec',
              onChanged: (int val) => sec = val,
            ),
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
          color: time > 0 ? const Color(0xff3ddc85) : const Color(0xffff534d),
        ),
      ),
      subtitle: Text(desc),
      contentPadding: EdgeInsets.zero,
      title: Text(
        _timeString,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.timer),
        onPressed: () async {
          final int? duration = await _selectTime(context);
          if (duration != null) onChanged(duration);
        },
      ),
    );
  }
}

class _NumberPicker extends StatelessWidget {
  const _NumberPicker({
    required this.count,
    required this.label,
    required this.onChanged,
  });

  final int? count;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 150,
      child: Stack(alignment: Alignment.centerRight, children: <Widget>[
        ButtonWidget(
          right: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          left: const SizedBox(width: 45, height: 30),
        ),
        ListWheelScrollView(
          itemExtent: 30,
          magnification: 2,
          useMagnifier: true,
          onSelectedItemChanged: onChanged,
          physics: const FixedExtentScrollPhysics(),
          children: List<Widget>.generate((count ?? 10) + 1, (int index) {
            return Container(
              width: 35,
              alignment: Alignment.centerLeft,
              child: Text(
                '$index'.padLeft(2),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ),
      ]),
    );
  }
}
