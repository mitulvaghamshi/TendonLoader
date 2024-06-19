import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class TimePickerTile extends StatelessWidget {
  const TimePickerTile({
    super.key,
    required this.time,
    required this.label,
    required this.onPick,
  });

  final int time;
  final String label;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    late final duration = Duration(seconds: time);
    late int minutes = duration.inMinutes;
    late int seconds = duration.inSeconds % 60;
    return ExpansionTile(
      tilePadding: Styles.tilePadding,
      childrenPadding: Styles.tilePadding,
      title: Text(_timeString(minutes, seconds), style: Styles.bold18),
      subtitle: Text(label),
      children: [
        const RawButton.tile(
          color: Colors.green,
          axisAlignment: MainAxisAlignment.spaceEvenly,
          leading: Text('Minutes', style: Styles.whiteBold),
          child: Text('Seconds', style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        RawButton.tile(
          color: Colors.indigo,
          axisAlignment: MainAxisAlignment.spaceEvenly,
          leading: _NumberPicker(
            pickerSize: const Size(80, 130),
            maxValue: 60,
            initialValue: minutes,
            onChange: (value) => _submit(minutes = value, seconds),
          ),
          child: _NumberPicker(
            pickerSize: const Size(80, 130),
            maxValue: 60,
            initialValue: seconds,
            onChange: (value) => _submit(minutes, seconds = value),
          ),
        ),
      ],
    );
  }
}

extension on TimePickerTile {
  String _timeString(int minutes, int seconds) {
    final duration = Duration(minutes: minutes, seconds: seconds);
    return '${duration.inMinutes} min : ${duration.inSeconds % 60} sec';
  }

  void _submit(int minutes, int seconds) {
    final duration = Duration(minutes: minutes, seconds: seconds);
    onPick(duration.inSeconds);
  }
}

@immutable
class _NumberPicker extends StatelessWidget {
  const _NumberPicker({
    required this.pickerSize,
    required this.maxValue,
    required this.initialValue,
    required this.onChange,
  });

  final Size pickerSize;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22);
    return SizedBox.fromSize(
      size: pickerSize,
      child: ListWheelScrollView(
        squeeze: 0.5,
        itemExtent: 30,
        magnification: 2.5,
        useMagnifier: true,
        onSelectedItemChanged: onChange,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: initialValue),
        children: List.generate(maxValue + 1, (value) {
          return Text('$value'.padLeft(1), style: textStyle);
        }),
      ),
    );
  }
}
