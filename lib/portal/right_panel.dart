import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/portal/list_content.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/app/data_store.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<String>(
        stream: FilePath.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) return ListContent(future: () => DataStore.getUserData(snapshot.data));
          return const CustomImage(isLogo: true);
        },
      ),
    );
  }
}
