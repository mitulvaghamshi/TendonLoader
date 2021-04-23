import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({Key key, @required this.callback}) : super(key: key);

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Export',
      icon: Icons.backup_rounded,
      onPressed: () async {
        callback();
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          barrierColor: Theme.of(context).primaryColor,
          builder: (BuildContext context) {
            return Row(children: const <Widget>[CircularProgressIndicator(), Text('Please wait...', style: TextStyle(fontSize: 20))]);
          },
        );
      },
    );
  }
}
