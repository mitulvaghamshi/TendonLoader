import 'package:flutter/material.dart';
import 'package:tendon_loader/app/custom/custom_fab.dart';

class GraphControls extends StatelessWidget {
  const GraphControls({Key? key, this.start, this.stop, this.reset}) : super(key: key);

  final VoidCallback? start;
  final VoidCallback? stop;
  final VoidCallback? reset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CustomFab(onTap: start, icon: Icons.play_arrow_rounded),
        if (stop != null) CustomFab(onTap: stop, icon: Icons.stop_rounded),
        CustomFab(onTap: reset, icon: Icons.replay_rounded),
      ],
    );
  }
}
