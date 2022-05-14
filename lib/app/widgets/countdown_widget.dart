import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/utils/extension.dart';

@immutable
class CountdownWidget extends StatefulWidget {
  const CountdownWidget({Key? key, required this.duration}) : super(key: key);

  final Duration duration;

  @override
  CountdownWidgetState createState() => CountdownWidgetState();
}

class CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration + const Duration(seconds: 1),
  );

  String get _remainingTime {
    final int milli =
        (_controller.duration! * _controller.value).inMilliseconds;
    return milli < 1000 ? 'GO!' : (milli / 1000).truncate().toString();
  }

  @override
  void initState() {
    super.initState();
    _controller.reverse(
      from: _controller.value == 0.0 ? 1.0 : _controller.value,
    );
    _controller.addStatusListener((_) => context.pop(true));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, Widget? child) {
          return Stack(alignment: Alignment.center, children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _ProgressPainter(_controller)),
            ),
            FittedBox(
              child: Text(
                _remainingTime,
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

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter(this.controller) : super(repaint: controller);

  final Animation<double> controller;

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 25
      ..style = PaintingStyle.stroke
      ..color = const Color(0xff3ddc85);

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    canvas.drawArc(
      Offset.zero & size,
      pi * 1.5,
      controller.value * 2 * pi,
      false,
      paint..color = const Color(0xffffffff),
    );
  }
}
