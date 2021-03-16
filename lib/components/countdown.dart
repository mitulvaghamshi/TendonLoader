import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  const CountDown({this.title, this.duration});

  final String title;
  final Duration duration;

  static Future<bool> start(
    BuildContext context, {
    String title = 'Starts in',
    Duration duration = const Duration(seconds: 5),
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CountDown(title: title, duration: duration + Duration(seconds: 1)),
    );
  }

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> with TickerProviderStateMixin {
  AnimationController _controller;

  String get _timerString {
    if (_controller.value == 0) return 'GO!';
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

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
        child: Text(widget.title, style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Align(
              alignment: FractionalOffset.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: CustomPaint(painter: _CustomTimePainter(animation: _controller))),
                    Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          child,
                          Text(_timerString, style: const TextStyle(fontSize: 96, color: Colors.white)),
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

class _CustomTimePainter extends CustomPainter {
  const _CustomTimePainter({this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 20
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
