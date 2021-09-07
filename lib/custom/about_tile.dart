/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/utils/themes.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AboutListTile(
      applicationVersion: 'v0.1.0',
      applicationName: 'Tendon Loader',
      applicationLegalese: 'Please see the tendon_loader'
          ' license for copyright notice.',
      applicationIcon: SizedBox(
        width: 50,
        height: 50,
        child: AppLogo(),
      ),
      aboutBoxChildren: <Widget>[
        Divider(),
        Text(
          'Tendon Loader',
          style: tsG24B,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Tendon Loader is a project designed to measure '
          'and help overcome the Achilles Tendon Problems.',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Text(
          'Contact us:\n'
          'kohlemerry@gmail.com\n'
          'mitulvaghmashi@gmail.com',
          style: TextStyle(fontSize: 12),
        ),
      ],
      child: Text('About'),
    );
  }
}
