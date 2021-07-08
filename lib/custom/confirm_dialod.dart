import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomTile(
          name: 'Submit Now',
          color: colorGoogleGreen,
          icon: Icons.cloud_upload_rounded,
          onTap: () async {
            final bool result = await submitData(context, export, false);
            Navigator.of(context).pop(result);
          },
        ),
        CustomTile(
          name: 'Do it later',
          color: colorYellow400,
          icon: Icons.save_rounded,
          onTap: () async {
            final bool result = await submitData(context, export, true);
            Navigator.of(context).pop(result);
          },
        ),
        CustomTile(
          name: 'Discard!',
          color: colorRed400,
          icon: Icons.clear_rounded,
          onTap: () async => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
