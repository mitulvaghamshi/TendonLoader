import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class TimePickerTile extends StatelessWidget {
  const TimePickerTile({
    super.key,
    required this.time,
    required this.label,
    required this.onSelect,
  });

  final int time;
  final String label;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    Duration duration = .new(seconds: time);
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return ExpansionTile(
      tilePadding: Styles.tilePadding,
      childrenPadding: Styles.tilePadding,
      title: Text(_timeString(minutes, seconds), style: Styles.bold18),
      subtitle: Text(label),
      children: [
        ButtonFactory.tile(
          color: Theme.of(context).primaryColor,
          axisAlignment: .spaceEvenly,
          leading: const Text('Minutes', style: Styles.whiteBold),
          child: const Text('Seconds', style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        ButtonFactory.tile(
          color: Colors.indigo,
          axisAlignment: .spaceEvenly,
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
    Duration duration = .new(minutes: minutes, seconds: seconds);
    return '${duration.inMinutes} min : ${duration.inSeconds % 60} sec';
  }

  void _submit(int minutes, int seconds) {
    Duration duration = .new(minutes: minutes, seconds: seconds);
    onSelect(duration.inSeconds);
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
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: pickerSize,
    child: ListWheelScrollView(
      squeeze: 0.5,
      itemExtent: 30,
      magnification: 2.5,
      useMagnifier: true,
      onSelectedItemChanged: onChange,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialValue),
      children: .generate(maxValue + 1, (value) {
        return Text(
          '$value'.padLeft(1),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: .bold,
            fontSize: 22,
          ),
        );
      }),
    ),
  );
}
