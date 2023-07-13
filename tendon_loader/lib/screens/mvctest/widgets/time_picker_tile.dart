import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';

class TimePickerTile extends StatelessWidget {
  const TimePickerTile({
    super.key,
    required this.time,
    required this.desc,
    required this.onSelected,
  });

  final int time;
  final String desc;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    int min = 0;
    int sec = 0;
    return ExpansionTile(
      title: Text(
        _timeString,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: time > 0 ? const Color(0xff3ddc85) : const Color(0xffff534d),
        ),
      ),
      subtitle: Text(desc),
      tilePadding: Styles.tilePadding,
      children: [
        const Text('Select time and tap on item again to save'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberPicker(
              count: 60,
              label: 'Min',
              onUpdate: (val) => min = val,
            ),
            _NumberPicker(
              count: 60,
              label: 'Sec',
              onUpdate: (val) => sec = val,
            ),
          ],
        ),
      ],
      onExpansionChanged: (isExpanded) {
        if (!isExpanded) {
          final int seconds = Duration(minutes: min, seconds: sec).inSeconds;
          if (seconds > 0) onSelected(seconds);
        }
      },
    );
  }
}

class _NumberPicker extends StatelessWidget {
  const _NumberPicker({
    required this.count,
    required this.label,
    required this.onUpdate,
  });

  final int count;
  final String label;
  final ValueChanged<int> onUpdate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 150,
      child: Stack(alignment: Alignment.centerRight, children: [
        Text(label, style: Styles.numberPickerText),
        ListWheelScrollView(
          itemExtent: 30,
          magnification: 2,
          useMagnifier: true,
          onSelectedItemChanged: onUpdate,
          physics: const FixedExtentScrollPhysics(),
          children: List.generate(count + 1, (index) {
            return Container(
              width: 35,
              alignment: Alignment.centerLeft,
              child: Text('$index'.padLeft(2), style: Styles.numberPickerText),
            );
          }),
        ),
      ]),
    );
  }
}

extension on TimePickerTile {
  String get _timeString {
    final Duration duration = Duration(seconds: time);
    return '${duration.inMinutes} min : ${duration.inSeconds % 60} sec';
  }
}