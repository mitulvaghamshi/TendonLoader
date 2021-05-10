import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/extensions.dart' show ExTimer;

class CountDown extends StatefulWidget {
  const CountDown({Key key, this.title, this.duration}) : super(key: key);

  final Duration duration;
  final String title;

  static Future<bool> start(
    BuildContext context, {
    String title = 'Starts in',
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
  AnimationController _controller;

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
      body: AnimatedBuilder(
        animation: _controller,
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, color: Colors.white),
        ),
        builder: (_, Widget child) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Align(
              alignment: FractionalOffset.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: CustomPaint(painter: _CustomPainter(animation: _controller))),
                    Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          child,
                          Text(
                            (_controller.duration * _controller.value).inSeconds.toTime,
                            style: const TextStyle(fontSize: 96, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CustomPainter extends CustomPainter {
  const _CustomPainter({this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 15
      ..color = Colors.white
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    canvas.drawArc(
      Offset.zero & size,
      math.pi * 1.5,
      -(animation.value * 2 * math.pi),
      false,
      paint..color = Colors.black,
    );
  }
}
