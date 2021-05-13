import 'package:flutter/material.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/apphome.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({Key key, this.context, this.name, this.route, this.icon}) : super(key: key);

  final String name;
  final String route;
  final IconData icon;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30),
      contentPadding: const EdgeInsets.all(16),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      onTap: () {
        if (Bluetooth.isConnected) {
          Navigator.pushNamed(context, route);
        } else {
          AppHome.of(context).connectDevice();
        }
      },
    );
  }
}
// ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progressor not connected!')));
