import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

@immutable
final class TimePickerTile extends StatefulWidget {
  const TimePickerTile({
    super.key,
    required this.time,
    required this.label,
    required this.onChange,
  });

  final int time;
  final String label;
  final ValueChanged<int> onChange;

  @override
  State<TimePickerTile> createState() => _TimePickerTileState();
}

final class _TimePickerTileState extends State<TimePickerTile> {
  late final _duration = Duration(seconds: widget.time);
  late int _minutes = _duration.inMinutes;
  late int _seconds = _duration.inSeconds % 60;

  String get _timeString {
    final duration = Duration(minutes: _minutes, seconds: _seconds);
    return '${duration.inMinutes} min : ${duration.inSeconds % 60} sec';
  }

  void _submit(bool expanded) {
    if (!expanded) {
      final duration = Duration(minutes: _minutes, seconds: _seconds);
      widget.onChange(duration.inSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: _submit,
      tilePadding: Styles.tilePadding,
      childrenPadding: Styles.tilePadding,
      subtitle: Text(widget.label),
      title: Text(_timeString, style: Styles.titleStyle),
      children: [
        const RawButton.tile(
          color: Colors.green,
          axisAlignment: MainAxisAlignment.spaceEvenly,
          leading: Text('Minutes', style: Styles.boldWhite),
          child: Text('Seconds', style: Styles.boldWhite),
        ),
        const SizedBox(height: 8),
        RawButton.tile(
          color: Colors.indigo,
          leadingToChildSpace: 8,
          axisAlignment: MainAxisAlignment.spaceEvenly,
          leading: _NumberPicker(
            value: _minutes,
            onChange: (value) => setState(() => _minutes = value),
          ),
          child: _NumberPicker(
            value: _seconds,
            onChange: (value) => setState(() => _seconds = value),
          ),
        ),
      ],
    );
  }
}

@immutable
final class _NumberPicker extends StatelessWidget {
  const _NumberPicker({required this.value, required this.onChange});

  final int value;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 130,
      child: ListWheelScrollView(
        squeeze: 0.5,
        itemExtent: 30,
        magnification: 2.5,
        useMagnifier: true,
        onSelectedItemChanged: onChange,
        controller: FixedExtentScrollController(initialItem: value),
        physics: const FixedExtentScrollPhysics(),
        children: List.generate(61, (index) {
          return Text('$index'.padLeft(1), style: Styles.numPickerText);
        }),
      ),
    );
  }
}
