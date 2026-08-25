import 'package:flutter/material.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';

@immutable
class const FutureWrapper<T>({
  required final Future<T> future,
  required final Widget Function(T value) builder,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: future,
    builder: (_, snapshot) => snapshot.hasData
        ? builder(snapshot.requireData)
        : snapshot.hasError
        ? ButtonFactory.error(message: snapshot.error.toString())
        : const ButtonFactory.loading(centered: true),
  );
}
