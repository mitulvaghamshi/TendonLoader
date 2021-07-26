import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/screens/web/left_panel/user_tile.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 370,
      child: AppFrame(
        child: RefreshIndicator(
          color: colorGoogleGreen,
          onRefresh: () async {
            context.model.reload;
            context.view.refresh;
          },
          child: FutureBuilder<void>(
            future: context.model.fetch(),
            builder: (_, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return const CustomProgress();
              return ListView.separated(
                itemCount: context.model.users.length,
                itemBuilder: (_, int index) => UserTile(user: context.model.users[index]),
                separatorBuilder: (_, __) => Divider(color: Theme.of(context).accentColor),
              );
            },
          ),
        ),
      ),
    );
  }
}
