import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

@immutable
class FutureWrapper<T> extends StatelessWidget {
  const FutureWrapper({super.key, required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(T) builder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const RawButton.loading();
          } else if (snapshot.hasError) {
            return RawButton.error(
              scaffold: false,
              message: snapshot.error.toString(),
            );
          }
          return builder(snapshot.requireData);
        },
      ),
    );
  }
}
