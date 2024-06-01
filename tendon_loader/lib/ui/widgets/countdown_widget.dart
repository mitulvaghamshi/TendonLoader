import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@immutable
final class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key, required this.duration});

  final Duration duration;

  @override
  CountdownWidgetState createState() => CountdownWidgetState();
}

final class CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: widget.duration + const Duration(seconds: 1));

  void _onFinish(_) {
    if (mounted) GoRouter.of(context).pop(true);
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
          _getRemainingTime(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.shortestSide / 3,
          ),
        ),
      ),
    ]);
  }
}

extension on CountdownWidgetState {
  String _getRemainingTime() {
    final int millis =
        (_controller.duration! * _controller.value).inMilliseconds;
    return millis < 500 ? 'GO!' : (millis / 1000).truncate().toString();
  }
}

@immutable
final class _CirclePainter extends CustomPainter {
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
