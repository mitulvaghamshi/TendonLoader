import 'package:flutter/material.dart';
import 'package:tendon_loader/components/bluetooth.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({this.context, this.name, this.route, this.icon});

  final BuildContext context;
  final String name;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30.0),
      contentPadding: const EdgeInsets.all(16.0),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      title: Text(name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      onTap: () {
        if (true || Bluetooth.device != null)
          Navigator.of(context).pushNamed(route);
        else {
          Scaffold.of(context).showSnackBar(SnackBar(content: const Text('Progressor not connected!')));
        }
      },
    );
  }
}
