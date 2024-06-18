import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@immutable
class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key, required this.duration});

  final Duration duration;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration + const Duration(seconds: 1),
  );

  void _onFinish(_) {
    if (mounted) context.pop(true);
  }

  @override
  void initState() {
    super.initState();
    _controller
      ..reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value)
      ..addStatusListener(_onFinish);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onFinish)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(painter: _CirclePainter(_controller)),
      ),
      AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => Text(
          _remainingTime,
          style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}

@immutable
class _CirclePainter extends CustomPainter {
  const _CirclePainter(this.controller) : super(repaint: controller);

  final Animation<double> controller;

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = size.width * 0.07
      ..style = PaintingStyle.stroke
      ..color = const Color(0xff3ddc85);
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2.5;

    canvas
      ..drawCircle(center, radius, paint)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi * 1.5,
        controller.value * pi * 2,
        false,
        paint..color = const Color(0xffffffff),
      );
  }
}

extension on _CountdownWidgetState {
  String get _remainingTime {
    final millis = (_controller.duration! * _controller.value).inMilliseconds;
    return millis < 1000 ? 'GO!' : (millis / 1000).truncate().toString();
  }
}
