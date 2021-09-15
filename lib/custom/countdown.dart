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

import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class CountDown extends StatefulWidget {
  const CountDown({Key? key, required this.duration}) : super(key: key);

  final Duration duration;

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> with TickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration + const Duration(seconds: 1),
  );

  String get _getTime {
    final int _millies = (_ctrl.duration! * _ctrl.value).inMilliseconds;
    return _millies < 1000 ? 'GO!' : (_millies / 1000).truncate().toString();
  }

  @override
  void initState() {
    super.initState();
    _ctrl.reverse(from: _ctrl.value == 0.0 ? 1.0 : _ctrl.value);
    _ctrl.addStatusListener((_) => context.pop(true));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, Widget? child) {
          return Stack(alignment: Alignment.center, children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _ProgrssPainter(_ctrl)),
            ),
            FittedBox(
              child: Text(
                _getTime,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 130,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _ProgrssPainter extends CustomPainter {
  const _ProgrssPainter(this.ctrl) : super(repaint: ctrl);

  final Animation<double> ctrl;

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 25
      ..color = colorMidGreen
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      paint,
    );
    canvas.drawArc(
      Offset.zero & size,
      pi * 1.5,
      ctrl.value * 2 * pi,
      false,
      paint..color = colorPrimaryWhite,
    );
  }
}
