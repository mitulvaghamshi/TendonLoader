import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/constants/others.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web_portal/custom/user_list_item.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  Future<void> _onRefresh() async {
    context.model.reload();
    context.view.refresh();
    // AppStateScope.of(context).reload();
    // AppStateWidget.of(context).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: sizeleftPanel,
      child: AppFrame(
        child: RefreshIndicator(
          color: colorGoogleGreen,
          onRefresh: _onRefresh,
          child: FutureBuilder<void>(
            future: context.model.fetch(),
            builder: (_, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) return const UserListItem();
              return const CustomProgress();
            },
          ),
        ),
      ),
    );
  }
}
