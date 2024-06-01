import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

@immutable
final class FutureHandler<T> extends StatelessWidget {
  const FutureHandler({
    super.key,
    required this.future,
    required this.builder,
  });

  final Future<T> future;
  final Widget Function(T value) builder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.requireData);
          } else if (snapshot.hasError) {
            return RawButton.error(
              scaffold: false,
              message: snapshot.error.toString(),
            );
          }
          return const RawButton.loading();
        },
      ),
    );
  }
}
