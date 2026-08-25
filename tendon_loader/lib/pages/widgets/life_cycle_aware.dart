import 'package:flutter/material.dart';

@immutable
class const LifeCycleAware({
  required final VoidCallback onPause,
  required final VoidCallback onResume,
  required final WidgetBuilder builder,
  super.key,
}) extends StatefulWidget {
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
