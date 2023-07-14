import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/screens/web/widgets/prescription_view.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    const export = Exercise.empty();
    // AppScope.of(context).userState.excercise;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('export.title'),
      ),
      child: SafeArea(child: PrescriptionView.export(export)),
    );
  }
}
