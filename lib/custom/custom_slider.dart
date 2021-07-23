import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/textstyles.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key, required this.onChanged}) : super(key: key);

  final ValueChanged<double> onChanged;

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Please describe your pain during that session', style: ts18BFF, textAlign: TextAlign.center),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 50,
              thumbShape: const _CustomThumb(),
              showValueIndicator: ShowValueIndicator.never,
              activeTrackColor: Color.lerp(colorAGreen400, colorRed400, value / 10),
              inactiveTrackColor: Color.lerp(colorAGreen400, colorRed400, value / 10),
              valueIndicatorTextStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            child: Slider(
              max: 10,
              value: value,
              divisions: 10,
              label: value.round().toString(),
              onChanged: (double val) => setState(() => widget.onChanged(value = val)),
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          _buildText('0\n\nNo\npain', colorAGreen400),
          _buildText('5\n\nModerate\npain', colorModerate),
          _buildText('10\n\nWorst\npain', colorRed400),
        ]),
      ],
    );
  }

  Text _buildText(String text, Color color) => Text(text,
      textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w900, letterSpacing: 1.5));
}

class _CustomThumb extends SliderComponentShape {
  const _CustomThumb();

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
    context.canvas.drawCircle(center, sliderTheme.trackHeight! / 2 + 5, Paint()..color = colorWhite);
    context.canvas.drawCircle(center, sliderTheme.trackHeight! / 2, Paint());
    labelPainter.paint(
      context.canvas,
      Offset(center.dx - (labelPainter.width / 2), center.dy - (labelPainter.height / 2)),
    );
  }
}
