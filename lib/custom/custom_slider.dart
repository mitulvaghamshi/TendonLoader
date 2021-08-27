import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final double value;
  final ValueChanged<double> onChanged;
  Color? get _trackColor => Color.lerp(colorDarkGreen, colorErrorRed, value / 10);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 50,
        thumbShape: _CustomShape(),
        valueIndicatorTextStyle: tsW24B,
        showValueIndicator: ShowValueIndicator.never,
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
      Paint()..color = colorPrimaryWhite,
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
