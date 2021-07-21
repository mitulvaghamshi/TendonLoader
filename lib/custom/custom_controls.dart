import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';

class GraphControls extends StatelessWidget {
  const GraphControls({Key? key, this.start, this.pause, this.stop}) : super(key: key);

  final VoidCallback? start;
  final VoidCallback? pause;
  final VoidCallback? stop;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      CustomButton(onPressed: start, icon: const Icon(Icons.play_arrow)),
      if (pause != null) CustomButton(onPressed: pause, icon: const Icon(Icons.pause)),
      CustomButton(onPressed: stop, icon: const Icon(Icons.stop)),
    ]);
  }
}
