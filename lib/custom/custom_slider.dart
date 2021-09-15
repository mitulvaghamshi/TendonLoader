/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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
