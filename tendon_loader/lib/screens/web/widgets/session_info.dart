import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/network/app_scope.dart';
import 'package:tendon_loader/screens/web/widgets/prescription_view.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final export = AppScope.of(context).api.excercise;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('export.title'),
      ),
      child: SafeArea(child: PrescriptionView.export(export)),
    );
  }
}
