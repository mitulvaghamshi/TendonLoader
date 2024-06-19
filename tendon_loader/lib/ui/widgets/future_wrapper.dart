import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

@immutable
class FutureWrapper<T> extends StatelessWidget {
  const FutureWrapper({super.key, required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(T) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (_, snapshot) => snapshot.hasData
          ? builder(snapshot.requireData)
          : snapshot.hasError
              ? RawButton.error(message: snapshot.error.toString())
              : const RawButton.loading(centered: true),
    );
  }
}
