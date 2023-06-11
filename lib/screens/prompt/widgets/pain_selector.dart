import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';

class PainSelector extends StatefulWidget {
  const PainSelector({super.key, required this.onSelect});

  final ValueChanged<double> onSelect;

  @override
  State<PainSelector> createState() => _PainSelectorState();
}

class _PainSelectorState extends State<PainSelector> {
  double painScore = 0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 30,
        thumbShape: _CustomShape(),
        trackShape: RoundedRectSliderTrackShape(),
        showValueIndicator: ShowValueIndicator.never,
        valueIndicatorTextStyle: Styles.titleStyle,
      ),
      child: Slider(
        max: 10,
        value: painScore,
        activeColor: _trackColor,
        inactiveColor: _trackColor,
        label: painScore.toStringAsFixed(1),
        onChangeEnd: widget.onSelect,
        onChanged: (value) => setState(() => painScore = value),
      ),
    );
  }
}

class _CustomShape extends SliderComponentShape {
  const _CustomShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    context.canvas.drawCircle(
      center,
      sliderTheme.trackHeight! * 0.7,
      Paint()..color = Colors.blueGrey,
    );
    labelPainter.paint(
      context.canvas,
      Offset(center.dx - (labelPainter.width / 2),
          center.dy - (labelPainter.height / 2)),
    );
  }
}

extension on _PainSelectorState {
  Color? get _trackColor => Color.lerp(
      const Color(0xff00e676), const Color(0xffff534d), painScore / 10);
}
