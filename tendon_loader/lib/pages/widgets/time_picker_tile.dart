import 'package:flutter/material.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class const TimePickerTile({
  required final int time,
  required final String label,
  required final ValueChanged<int> onSelect,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: time);
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
    final duration = Duration(minutes: minutes, seconds: seconds);
    return '${duration.inMinutes} min : ${duration.inSeconds % 60} sec';
  }

  void _submit(int minutes, int seconds) {
    final duration = Duration(minutes: minutes, seconds: seconds);
    onSelect(duration.inSeconds);
  }
}

@immutable
class const _NumberPicker({
  required final Size pickerSize,
  required final int maxValue,
  required final int initialValue,
  required final ValueChanged<int> onChange,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontWeight: .bold,
      fontSize: 22,
    );

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
        children: .generate(maxValue + 1, (value) {
          return Text('$value'.padLeft(1), style: textStyle);
        }),
      ),
    );
  }
}
