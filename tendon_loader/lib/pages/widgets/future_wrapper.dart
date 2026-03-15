import 'package:flutter/material.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';

@immutable
class FutureWrapper<T> extends StatelessWidget {
  const FutureWrapper({required this.future, required this.builder, super.key});

  final Future<T> future;
  final Widget Function(T value) builder;

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: future,
    builder: (_, snapshot) => snapshot.hasData
        ? builder(snapshot.requireData)
        : snapshot.hasError
        ? ButtonFactory.error(message: snapshot.error.toString())
        : const ButtonFactory.loading(centered: true),
  );
}
