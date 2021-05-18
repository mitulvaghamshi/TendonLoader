import 'package:flutter/material.dart';

class GraphControls extends StatelessWidget {
  const GraphControls({Key key, this.start, this.stop, this.reset}) : super(key: key);

  final VoidCallback start;
  final VoidCallback stop;
  final VoidCallback reset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <FloatingActionButton>[
        FloatingActionButton(onPressed: start, heroTag: 'start-btn', child: const Icon(Icons.play_arrow_rounded)),
        if (stop != null)
          FloatingActionButton(onPressed: stop, heroTag: 'stop-btn', child: const Icon(Icons.stop_rounded)),
        FloatingActionButton(onPressed: reset, heroTag: 'reset-btn', child: const Icon(Icons.replay_rounded)),
      ],
    );
  }
}
