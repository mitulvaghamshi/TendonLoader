import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';

class GraphControls extends StatelessWidget {
  const GraphControls({Key? key, this.start, this.stop, this.reset}) : super(key: key);

  final VoidCallback? start;
  final VoidCallback? stop;
  final VoidCallback? reset;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      CustomButton(onPressed: start, icon: const Icon(Icons.play_arrow_rounded)),
      if (stop != null) CustomButton(onPressed: stop, icon: const Icon(Icons.stop_rounded)),
      CustomButton(onPressed: reset, icon: const Icon(Icons.replay_rounded)),
    ]);
  }
}
