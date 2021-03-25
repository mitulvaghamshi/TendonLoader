import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({Key key, this.context, this.name, this.route, this.icon}) : super(key: key);

  final String name;
  final String route;
  final IconData icon;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        leading: Icon(icon, size: 30),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        onTap: () {
          if (Bluetooth.instance.waiting)
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Too fast! device busy, try again!!!')));
          /*else if (false */ /* Bluetooth.device == null*/ /*) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Progressor not connected!')));
          } else {
          }*/
          Navigator.of(context).pushNamed(route);
        },
      ),
    );
  }
}
