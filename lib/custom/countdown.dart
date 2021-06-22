import 'dart:math' show pi;
import 'dart:ui' show Canvas, Offset, Paint, PaintingStyle, Size, TextAlign;

import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/extension.dart';

class CountDown extends StatefulWidget {
  const CountDown({Key? key, this.title, this.duration}) : super(key: key);

  final Duration? duration;
  final String? title;

  static Future<bool?> start(
    BuildContext context, {
    String title = 'Session start in',
    Duration duration = const Duration(seconds: 5),
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CountDown(title: title, duration: duration + const Duration(seconds: 1)),
    );
  }

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _controller.addStatusListener((_) => Navigator.pop<bool>(context, true));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Chip(
          padding: const EdgeInsets.all(10),
          backgroundColor: Theme.of(context).accentColor,
          label: Text(
            widget.title!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, Widget? child) => Stack(alignment: Alignment.center, children: <Widget>[
                Positioned.fill(child: CustomPaint(painter: _Painter(_controller))),
                Text(
                  (_controller.duration! * _controller.value).inSeconds.toTime,
                  style: const TextStyle(fontSize: 100, color: Colors.white),
                ),
              ]),
            ),
          ),
        ),
      ]),
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
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    canvas.drawArc(Offset.zero & size, pi * 1.5, -(ctrl!.value * 2 * pi), false, paint..color = Colors.white);
  }
}
