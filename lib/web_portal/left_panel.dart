import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/constants/others.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/web_portal/user_list_item.dart'; 
class LeftPanel extends StatefulWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  Future<void> _onRefresh() async {
    AppStateScope.of(context).markDirty();
    AppStateWidget.of(context).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: sizeleftPanel,
      child: AppFrame(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder<void>(
            future: AppStateScope.of(context).fetchAll(),
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
