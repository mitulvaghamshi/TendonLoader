import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/web/widgets/prescription_view.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Export export = AppState.of(context).getSelectedExport();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(export.title),
      ),
      child: SafeArea(child: PrescriptionView.export(export)),
    );
  }
}
