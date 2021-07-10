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
  late final AnimationController ctrl =
      AnimationController(vsync: this, duration: widget.duration + const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    ctrl.reverse(from: ctrl.value == 0.0 ? 1.0 : ctrl.value);
    ctrl.addStatusListener((_) => Navigator.pop<bool>(context, true));
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (_, Widget? child) => Stack(alignment: Alignment.center, children: <Widget>[
          Positioned.fill(child: CustomPaint(painter: _Painter(ctrl))),
          FittedBox(
            child: Text(
              (ctrl.duration! * ctrl.value).inMilliseconds.toSec,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 150),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  const _Painter(this.ctrl) : super(repaint: ctrl);

  final Animation<double>? ctrl;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 25
      ..color = colorGoogleGreen
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    canvas.drawArc(Offset.zero & size, pi * 1.5, ctrl!.value * 2 * pi, false, paint..color = colorWhite);
  }
}
