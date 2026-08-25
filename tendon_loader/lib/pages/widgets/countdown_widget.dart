import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@immutable
class const CountdownWidget({required final Duration duration, super.key})
    extends StatefulWidget {
  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration + const .new(seconds: 1),
  );

  void _onFinish(_) {
    if (mounted) {
      context.pop(true);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onFinish);
    _controller.reverse(
      from: _controller.value == 0.0 ? 1.0 : _controller.value,
    );
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onFinish);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    alignment: .center,
    children: [
      AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(painter: _CirclePainter(_controller)),
      ),
      AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => Text(
          _remainingTime,
          style: const .new(fontSize: 100, fontWeight: .bold),
        ),
      ),
    ],
  );
}

@immutable
class const _CirclePainter(final Animation<double> controller)
    extends CustomPainter {
  this : super(repaint: controller);

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = .stroke
      ..strokeWidth = size.width * .07
      ..color = const Color(0xff3ddc85);
    final center = size.center(.zero);
    final radius = size.width / 2.5;

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
