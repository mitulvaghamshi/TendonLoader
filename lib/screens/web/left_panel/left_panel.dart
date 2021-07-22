import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/screens/web/left_panel/user_list_item.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 370,
      child: AppFrame(
        child: RefreshIndicator(
          color: colorGoogleGreen,
          onRefresh: () async => context
            ..model.reload
            ..view.refresh,
          child: FutureBuilder<void>(
            future: context.model.fetch(),
            builder: (_, AsyncSnapshot<void> snapshot) =>
                snapshot.connectionState == ConnectionState.done ? const UserListItem() : const CustomProgress(),
          ),
        ),
      ),
    );
  }
}
