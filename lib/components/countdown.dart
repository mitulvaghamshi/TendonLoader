import 'dart:math' as math;

import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  const CountDown({this.duration, this.title});

  final Duration duration;
  final String title;

  static Future<bool> start(
    BuildContext context, [
    Duration duration = const Duration(seconds: 5),
    String title = 'Starts in',
  ]) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CountDown(duration: duration + Duration(seconds: 1), title: title),
    );
  }

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> with TickerProviderStateMixin {
  AnimationController _controller;

  String get _timerString {
    if(_controller.value == 0) return 'GO!';
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
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _controller,
        child: Text(widget.title, style: TextStyle(fontSize: 36, color: Colors.white)),
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(50),
            child: Align(
              alignment: FractionalOffset.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CustomTimerPainter(
                          animation: _controller,
                          backgroundColor: Colors.white,
                          color: themeData.indicatorColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          child,
                          Text(_timerString, style: TextStyle(fontSize: 96, color: Colors.white)),
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

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({this.animation, this.backgroundColor, this.color}) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    paint.color = color;
    double progress = (animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value || color != old.color || backgroundColor != old.backgroundColor;
  }
}
