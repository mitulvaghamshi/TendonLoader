import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 50,
        activeTrackColor: Colors.greenAccent,
        inactiveTrackColor: Colors.red.shade100,
        thumbShape: const _CustomThumb(radius: 25),
        showValueIndicator: ShowValueIndicator.never,
        valueIndicatorTextStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
      ),
      child: Slider(
        max: 10,
        value: value,
        divisions: 10,
        label: value.round().toString(),
        onChanged: (double newValue) => setState(() => value = newValue),
      ),
    );
  }
}

class _CustomThumb extends SliderComponentShape {
  const _CustomThumb({required this.radius});

  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(radius);

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
    context.canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    context.canvas.drawCircle(center, radius * .8, Paint()..color = Colors.blueAccent);
    labelPainter.paint(
      context.canvas,
      Offset(center.dx - (labelPainter.width / 2), center.dy - (labelPainter.height / 2)),
    );
  }
}
