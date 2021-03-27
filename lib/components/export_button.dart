import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({Key/*?*/ key, /*required*/ @required this.callback}) : super(key: key);

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Export',
      icon: Icons.backup_rounded,
      onPressed: () async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            callback();
            Future<void>.delayed(const Duration(seconds: 2), () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported successful!!!')));
              Navigator.pop<void>(context);
            });
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[CircularProgressIndicator(), Text('Please wait...', style: TextStyle(fontSize: 20))],
            );
          },
        );
      },
    );
  }
}
