import 'package:flutter/material.dart';

@immutable
class LifeCycleAware extends StatefulWidget {
  const LifeCycleAware({
    required this.onPause,
    required this.onResume,
    required this.builder,
    super.key,
  });

  final VoidCallback onPause;
  final VoidCallback onResume;
  final WidgetBuilder builder;

  @override
  State<LifeCycleAware> createState() => _LifeCycleAwareState();
}

class _LifeCycleAwareState extends State<LifeCycleAware>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    (switch (state) {
      .paused => widget.onPause,
      .resumed => widget.onResume,
      _ => () {},
    })();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
