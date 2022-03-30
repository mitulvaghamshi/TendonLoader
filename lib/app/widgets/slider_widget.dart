import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final double value;
  final ValueChanged<double> onChanged;

  Color? get _trackColor {
    return Color.lerp(
      const Color(0xff00e676),
      const Color(0xffff534d),
      value / 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 50,
        thumbShape: _CustomShape(),
        showValueIndicator: ShowValueIndicator.never,
        valueIndicatorTextStyle: TextStyle(
          fontSize: 24,
          color: Color(0xffffffff),
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Slider(
        max: 10,
        value: value,
        divisions: 10,
        onChanged: onChanged,
        activeColor: _trackColor,
        inactiveColor: _trackColor,
        label: value.toStringAsFixed(0),
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
      sliderTheme.trackHeight! / 2 + 5,
      Paint()..color = const Color(0xffffffff),
    );
    context.canvas.drawCircle(
      center,
      sliderTheme.trackHeight! / 2,
      Paint(),
    );
    labelPainter.paint(
      context.canvas,
      Offset(
        center.dx - (labelPainter.width / 2),
        center.dy - (labelPainter.height / 2),
      ),
    );
  }
}
